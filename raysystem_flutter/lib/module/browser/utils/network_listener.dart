import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:webview_flutter/webview_flutter.dart';

/// Callback function type for handling network log messages.
typedef NetworkLogCallback = void Function(Map<String, dynamic> logData);

/// Manages the injection of network monitoring JavaScript and communication
/// between the WebView and Flutter.
class NetworkListener {
  static const _channelName = 'NetworkListenerChannel';
  final WebViewController _webViewController;
  final NetworkLogCallback? onNetworkLog;
  bool _isScriptInjected = false;
  String? _networkListenerScript;

  NetworkListener({
    required WebViewController webViewController,
    this.onNetworkLog,
  }) : _webViewController = webViewController {
    _setup();
  }

  bool isScriptInjected() => _isScriptInjected;

  Future<void> _setup() async {
    await _loadScript();
    await _addJavaScriptChannel();
    // Try injecting the script immediately in case the controller is already ready
    await injectScript();
  }

  /// Loads the network listener JavaScript from assets.
  Future<void> _loadScript() async {
    try {
      _networkListenerScript =
          await rootBundle.loadString('assets/js/network_listener.js');
      debugPrint('Network listener script loaded successfully.');
    } catch (e) {
      debugPrint('Error loading network listener script: $e');
      _networkListenerScript = null; // Ensure it's null if loading fails
    }
  }

  /// Adds the JavaScript channel to the WebView controller.
  Future<void> _addJavaScriptChannel() async {
    try {
      await _webViewController.addJavaScriptChannel(
        _channelName,
        onMessageReceived: (JavaScriptMessage message) {
          if (kDebugMode) {
            // print('Raw message from JS: ${message.message}');
          }
          try {
            final logData = jsonDecode(message.message) as Map<String, dynamic>;
            // Optionally process or format the log data here
            if (kDebugMode) {
              // Pretty print the JSON in debug mode
              const jsonEncoder = JsonEncoder.withIndent('  ');
              final prettyJson = jsonEncoder.convert(logData);
              print('Network Log Received:$prettyJson');
            }
            onNetworkLog?.call(logData);
          } catch (e) {
            debugPrint('Error decoding network log message: $e');
            debugPrint('Received message: ${message.message}');
          }
        },
      );
      debugPrint('JavaScript channel "$_channelName" added.');
    } catch (e) {
      debugPrint('Error adding JavaScript channel "$_channelName": $e');
      // Handle cases where the channel might already exist or other errors
      if (e.toString().contains('already exists')) {
        debugPrint(
            'Channel "$_channelName" likely already exists. Proceeding.');
      } else {
        // Rethrow or handle other specific errors if necessary
      }
    }
  }

  /// Injects the network listener script into the WebView.
  /// Ensures the script is loaded and not already injected.
  Future<void> injectScript() async {
    if (_isScriptInjected) {
      // debugPrint('Network listener script already injected.');
      return;
    }
    if (_networkListenerScript == null) {
      debugPrint('Network listener script not loaded. Cannot inject.');
      // Optionally try loading again
      // await _loadScript();
      // if (_networkListenerScript == null) return;
      return;
    }

    try {
      await _webViewController.runJavaScript(_networkListenerScript!);
      _isScriptInjected = true; // Mark as injected *after* successful execution
      debugPrint('Network listener script injected successfully.');
    } catch (e) {
      debugPrint('Error injecting network listener script: $e');
      _isScriptInjected = false; // Ensure it's marked as not injected on error
    }
  }

  /// Resets the injection status, allowing the script to be injected again.
  /// Useful if the WebView reloads or navigates to a new page where the
  /// script might be lost.
  void resetInjectionStatus() {
    _isScriptInjected = false;
    // window._networkListenerInjected is reset within the JS script itself
    // if it runs again, but we reset the Dart-side flag here.
    debugPrint('Network listener injection status reset.');
  }
}
