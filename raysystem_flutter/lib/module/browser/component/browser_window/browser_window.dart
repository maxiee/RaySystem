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

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          print('WebView is loading (progress: $progress%)');
        },
        onPageStarted: (url) {
          print('Page started loading: $url');
        },
        onPageFinished: (url) {
          print('Page finished loading: $url');
        },
        onWebResourceError: (error) {
          print('Web resource error: $error');
        },
        onHttpError: (error) {
          print('HTTP error: $error');
        },
        onNavigationRequest: (navigationRequest) {
          print('Navigation request: $navigationRequest');
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _webViewController,
    );
  }
}
