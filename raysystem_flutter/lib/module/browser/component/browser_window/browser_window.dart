import 'package:flutter/material.dart';
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
          return NavigationDecision.navigate;
        },
      ))
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

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _webViewController,
    );
  }
}
