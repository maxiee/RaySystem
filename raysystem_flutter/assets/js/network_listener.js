(function() {
    // 防止重复注入
    if (window._networkListenerInjected) {
        console.log('Network listener already injected.');
        return;
    }
    window._networkListenerInjected = true;
    console.log('Injecting network listener...');

    const channelName = 'NetworkListenerChannel'; // 与 Dart 端定义的 Channel 名称一致

    // --- Helper function to send data to Flutter ---
    function sendDataToFlutter(data) {
        if (window[channelName] && window[channelName].postMessage) {
            try {
                // 只发送关键信息，避免循环引用和过大数据
                const simplifiedData = {
                    type: data.type,
                    url: data.url,
                    method: data.method,
                    requestHeaders: data.requestHeaders,
                    // 限制请求体大小，并尝试转为字符串
                    requestBody: data.requestBody ? String(data.requestBody) : null,
                    status: data.status,
                    responseHeaders: data.responseHeaders,
                    // 限制响应体大小
                    responseBody: data.responseBody ? JSON.stringify(data.responseBody) : null,
                    timestamp: data.timestamp || Date.now(),
                    duration: data.duration
                };
                window[channelName].postMessage(JSON.stringify(simplifiedData));
            } catch (e) {
                console.error('Error sending data to Flutter:', e, data);
                // 尝试发送错误信息
                try {
                    window[channelName].postMessage(JSON.stringify({
                        error: 'Failed to serialize data',
                        message: e.message,
                        url: data.url,
                        method: data.method
                    }));
                } catch (sendError) {
                     console.error('Failed to send error report to Flutter:', sendError);
                }
            }
        } else {
            // console.warn(`Flutter channel "${channelName}" not found. Data not sent:`, data);
        }
    }

    // --- Intercept Fetch ---
    const originalFetch = window.fetch;
    window.fetch = function(input, init) {
        const requestTimestamp = Date.now();
        let url = '';
        let method = 'GET';
        let requestHeaders = {};
        let requestBody = null;

        if (typeof input === 'string') {
            url = input;
        } else if (input instanceof Request) {
            url = input.url;
            method = input.method;
            requestHeaders = Object.fromEntries(input.headers.entries());
            // Reading request body here might consume it. We'll capture it from 'init' if provided.
            // If needed, clone the request: requestBody = await input.clone().text(); (requires async)
        } else {
            // Handle URL object input
             url = input.toString();
        }


        if (init) {
            method = init.method || method;
            if (init.headers) {
                 if (init.headers instanceof Headers) {
                    requestHeaders = Object.fromEntries(init.headers.entries());
                 } else if (typeof init.headers === 'object') {
                    requestHeaders = init.headers;
                 }
            }
            requestBody = init.body; // Can be string, Blob, FormData, etc.
        }

        const requestData = {
            type: 'fetch',
            url: url,
            method: method.toUpperCase(),
            requestHeaders: requestHeaders,
            requestBody: requestBody,
            timestamp: requestTimestamp
        };

        return originalFetch(input, init).then(async (response) => {
            const responseClone = response.clone();
            const responseHeaders = Object.fromEntries(responseClone.headers.entries());
            let responseBody = null;
            try {
                const contentType = responseClone.headers.get('content-type') || '';
                if (contentType.includes('application/json')) {
                    responseBody = await responseClone.json();
                } else if (contentType.startsWith('text/')) {
                    responseBody = await responseClone.text();
                } else {
                     responseBody = `[Non-text body, Content-Type: ${contentType}]`;
                }
            } catch (e) {
                console.error('Error reading fetch response body:', e);
                try {
                    // Fallback: try reading as text if JSON/other parsing failed
                    responseBody = await responseClone.text();
                } catch (textError) {
                     console.error('Error reading fetch response body as text:', textError);
                     responseBody = '[Error reading response body]';
                }
            }

            const responseData = {
                ...requestData,
                status: responseClone.status,
                responseHeaders: responseHeaders,
                responseBody: responseBody,
                duration: Date.now() - requestTimestamp
            };
            sendDataToFlutter(responseData);
            return response;
        }).catch((error) => {
             console.error('Fetch network error:', error);
             const errorData = {
                 ...requestData,
                 status: 0, // Indicate network error
                 responseBody: error.message,
                 duration: Date.now() - requestTimestamp
             };
             sendDataToFlutter(errorData);
             throw error;
        });
    };

    // --- Intercept XMLHttpRequest ---
    const originalXhrOpen = XMLHttpRequest.prototype.open;
    const originalXhrSend = XMLHttpRequest.prototype.send;
    const originalSetRequestHeader = XMLHttpRequest.prototype.setRequestHeader;
    const xhrDataMap = new WeakMap();

    XMLHttpRequest.prototype.open = function(method, url) {
        const xhr = this;
        const requestTimestamp = Date.now();
        // Store initial data, request headers will be added via setRequestHeader
        xhrDataMap.set(xhr, {
            type: 'xhr',
            method: method.toUpperCase(),
            url: url,
            requestHeaders: {}, // Initialize as empty object
            timestamp: requestTimestamp
        });

        xhr.addEventListener('loadend', function() {
            if (!xhrDataMap.has(xhr)) return; // Already processed or irrelevant XHR

            const requestData = xhrDataMap.get(xhr);
            let responseBody = null;
            let responseHeaders = {};
            try {
                const headersStr = xhr.getAllResponseHeaders();
                if (headersStr) {
                    const headerPairs = headersStr.trim().split(/[\r\n]+/);
                    headerPairs.forEach(line => {
                        const parts = line.split(': ');
                        if (parts.length === 2) {
                           responseHeaders[parts[0].toLowerCase()] = parts[1];
                        }
                    });
                }

                const contentType = responseHeaders['content-type'] || '';
                 if (xhr.responseType === '' || xhr.responseType === 'text') {
                     if (contentType.includes('application/json') && typeof xhr.responseText === 'string') {
                         try {
                            responseBody = JSON.parse(xhr.responseText);
                         } catch (e) {
                             console.warn('Failed to parse JSON response for XHR, falling back to text:', xhr.responseText);
                             responseBody = xhr.responseText;
                         }
                     } else {
                        responseBody = xhr.responseText;
                     }
                 } else if (xhr.responseType === 'json') {
                     responseBody = xhr.response; // Already parsed by the browser
                 } else {
                     responseBody = `[Non-text response, ResponseType: ${xhr.responseType}]`;
                 }

            } catch (e) {
                console.error('Error processing XHR response:', e);
                responseBody = '[Error processing response]';
            }

            const responseData = {
                ...requestData,
                status: xhr.status,
                responseHeaders: responseHeaders,
                responseBody: responseBody,
                duration: Date.now() - requestData.timestamp
            };
            sendDataToFlutter(responseData);
            xhrDataMap.delete(xhr); // Clean up after sending
        });

         // Call the original open method
        originalXhrOpen.apply(this, arguments);
    };

     XMLHttpRequest.prototype.setRequestHeader = function(header, value) {
         if (xhrDataMap.has(this)) {
             const data = xhrDataMap.get(this);
             // Ensure requestHeaders exists
             data.requestHeaders = data.requestHeaders || {};
             data.requestHeaders[header.toLowerCase()] = value;
         }
         originalSetRequestHeader.apply(this, arguments);
     };

    XMLHttpRequest.prototype.send = function(body) {
        if (xhrDataMap.has(this)) {
            const data = xhrDataMap.get(this);
            data.requestBody = body; // Store request body (can be null, string, FormData, etc.)
        }
        originalXhrSend.apply(this, arguments);
    };

    console.log('Network listener injected successfully.');
})();
