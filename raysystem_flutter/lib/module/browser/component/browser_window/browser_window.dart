import 'package:flutter/foundation.dart'; // Import kDebugMode
import 'package:flutter/material.dart';
import 'package:raysystem_flutter/module/browser/utils/browser_utils.dart';
import 'package:raysystem_flutter/module/browser/utils/network_listener.dart'; // Import NetworkListener
import 'package:webview_flutter/webview_flutter.dart';

class BrowserWindow extends StatefulWidget {
  final String initialUrl;
  final void Function(String title)? onTitleChanged;

  const BrowserWindow({
    super.key,
    required this.initialUrl,
    this.onTitleChanged,
  });

  @override
  State<BrowserWindow> createState() => _BrowserWindowState();
}

class _BrowserWindowState extends State<BrowserWindow> {
  late WebViewController _webViewController;
  late String _currentUrl;
  late NetworkListener _networkListener;
  String _pageTitle = '';

  @override
  void initState() {
    super.initState();

    _currentUrl = widget.initialUrl;

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          if (progress > 25 && !_networkListener.isScriptInjected()) {
            debugPrint('Injecting script at progress: $progress%');
            _networkListener.injectScript();
          }
          // 在页面加载过程中获取标题
          if (progress > 50) {
            _updatePageTitle();
          }
        },
        onPageStarted: (url) {
          debugPrint('Page started loading: $url');
          _networkListener.resetInjectionStatus();
        },
        onPageFinished: (url) {
          debugPrint('Page finished loading: $url');
          if (!_networkListener.isScriptInjected()) {
            debugPrint('Injecting script on page finished (fallback)');
            _networkListener.injectScript();
          }
          // 页面加载完成后获取标题
          _updatePageTitle();
        },
        onWebResourceError: (error) {
          debugPrint('Web resource error: $error');
        },
        onHttpError: (error) {
          debugPrint('HTTP error: $error');
        },
        onNavigationRequest: (navigationRequest) {
          debugPrint('Navigation request: ${navigationRequest.url}');
          // Reset injection status before allowing navigation
          // Note: onPageStarted might be more reliable for this. Test which works best.
          // _networkListener.resetInjectionStatus();

          if (navigationRequest.url == 'about:blank') {
            debugPrint(
                'Allowing navigation to about:blank - this may be part of site functionality');
            return NavigationDecision.navigate;
          }

          // 强制将 HTTP 请求转换为 HTTPS
          // 如果检测到原始请求是 HTTP，就阻止这次导航
          // 然后通过 _loadUrl() 方法重新使用 HTTPS 发起请求
          if (navigationRequest.url.startsWith('http://')) {
            debugPrint('Redirecting HTTP to HTTPS: ${navigationRequest.url}');
            _loadUrl(BrowserUtils.ensureHttps(navigationRequest.url));
            return NavigationDecision.prevent;
          }

          debugPrint('Allowing navigation to: ${navigationRequest.url}');
          return NavigationDecision.navigate;
        },
      ))
      ..setUserAgent(
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15",
      );

    // Initialize NetworkListener *after* WebViewController is created
    _networkListener = NetworkListener(
      webViewController: _webViewController,
      onNetworkLog: (logData) {
        // Handle the received network log data here
        // Already printed nicely within NetworkListener in debug mode
        if (!kDebugMode) {
          // If not in debug mode, you might want to log differently or process the data
          // print('Network Log: $logData');
        }
      },
    );
    // Initial load
    _webViewController.loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  void didUpdateWidget(covariant BrowserWindow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialUrl != widget.initialUrl) {
      debugPrint('BrowserWindow URL changed: ${widget.initialUrl}');
      _currentUrl = widget.initialUrl;
      // Reset injection status when URL changes externally
      _networkListener.resetInjectionStatus();
      _webViewController.loadRequest(Uri.parse(_currentUrl));
      // URL变化后，等待页面加载并更新标题
    }
  }

  void _loadUrl(String url) {
    debugPrint('Loading URL: $url');
    // Reset injection status when loading a new URL manually
    _networkListener.resetInjectionStatus();
    _webViewController.loadRequest(Uri.parse(url));
    // loadRequest后，navigationDelegate会处理页面加载事件，
    // 在onPageFinished中会自动调用_updatePageTitle()
  }

  // 获取并更新页面标题的方法
  Future<void> _updatePageTitle() async {
    try {
      final title = await _webViewController.getTitle() ?? '';
      if (title != _pageTitle) {
        setState(() {
          _pageTitle = title;
        });
        // 通知父部件标题已更改
        if (widget.onTitleChanged != null) {
          widget.onTitleChanged!(title);
        }
      }
    } catch (e) {
      debugPrint('Error getting page title: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _webViewController,
    );
  }
}
