import 'package:flutter/material.dart';
import 'package:raysystem_flutter/module/browser/utils/browser_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserWindow extends StatefulWidget {
  final String initialUrl;
  const BrowserWindow({super.key, required this.initialUrl});

  @override
  State<BrowserWindow> createState() => _BrowserWindowState();
}

class _BrowserWindowState extends State<BrowserWindow> {
  late WebViewController _webViewController;
  late String _currentUrl;

  @override
  void initState() {
    super.initState();

    _currentUrl = widget.initialUrl;

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          debugPrint('WebView is loading (progress: $progress%)');
        },
        onPageStarted: (url) {
          debugPrint('Page started loading: $url');
        },
        onPageFinished: (url) {
          debugPrint('Page finished loading: $url');
        },
        onWebResourceError: (error) {
          debugPrint('Web resource error: $error');
        },
        onHttpError: (error) {
          debugPrint('HTTP error: $error');
        },
        onNavigationRequest: (navigationRequest) {
          debugPrint('Navigation request: $navigationRequest');
          if (navigationRequest.url == 'about:blank') {
            debugPrint('Blocking navigation to about:blank');
            return NavigationDecision.prevent;
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
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  void didUpdateWidget(covariant BrowserWindow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialUrl != widget.initialUrl) {
      debugPrint('BrowserWindow URL changed: ${widget.initialUrl}');
      _currentUrl = widget.initialUrl;
      _webViewController.loadRequest(Uri.parse(_currentUrl));
    }
  }

  void _loadUrl(String url) {
    debugPrint('Loading URL: $url');
    _webViewController.loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _webViewController,
    );
  }
}
