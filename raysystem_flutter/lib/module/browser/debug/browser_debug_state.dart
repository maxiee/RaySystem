import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math'; // 添加导入 for min

/// 表示一个网络请求日志的记录
class NetworkLogEntry {
  final DateTime timestamp;
  final Map<String, dynamic> data;
  final String id;

  NetworkLogEntry(this.data)
      : timestamp = DateTime.now(),
        id = const Uuid().v4();
}

/// 表示一个浏览器实例的调试状态
class BrowserDebugState with ChangeNotifier {
  final String instanceId;
  final String title;
  final List<NetworkLogEntry> _networkLogs = [];
  bool _isDevToolsOpen = false;

  BrowserDebugState({
    required this.instanceId,
    required this.title,
  });

  List<NetworkLogEntry> get networkLogs => List.unmodifiable(_networkLogs);
  bool get isDevToolsOpen => _isDevToolsOpen;

  /// 添加一条网络请求日志
  void addNetworkLog(Map<String, dynamic> logData) {
    final entry = NetworkLogEntry(logData);
    _networkLogs.add(entry);
    notifyListeners();
    if (kDebugMode) {
      print('Network log added to state[$instanceId]: ${entry.id}');
    }

    // 将 logData 以美观的文本格式存到本地磁盘
    _saveLogToFile(entry.id, logData);
  }

  dynamic _decodeAndBeautifyJsonStrings(dynamic item) {
    if (item is Map<String, dynamic>) {
      return item.map(
          (key, value) => MapEntry(key, _decodeAndBeautifyJsonStrings(value)));
    } else if (item is List) {
      return item
          .map((element) => _decodeAndBeautifyJsonStrings(element))
          .toList();
    } else if (item is String) {
      try {
        final decoded = jsonDecode(item);
        // If decoding is successful, recursively process to handle nested JSON strings
        if (decoded is Map<String, dynamic> || decoded is List) {
          return _decodeAndBeautifyJsonStrings(decoded);
        }
        // If decoded is not a collection (e.g. a number, boolean, or simple string that was JSON encoded)
        return decoded;
      } catch (e) {
        // Not a JSON string or malformed, return as is
        return item;
      }
    }
    return item;
  }

  String _generateFilename(Map<String, dynamic> logData, String entryId) {
    String sanitize(String input) {
      return input.replaceAll(RegExp(r'[\\/:*?"<>|\\s]'), '_').toLowerCase();
    }

    String urlString = "";
    dynamic request = logData['request'];
    if (request is Map && request['url'] is String) {
      urlString = request['url'];
    } else if (logData['url'] is String) {
      urlString = logData['url'];
    }

    String host = "unknown-host";
    String pathDetail = "unknown-path";

    if (urlString.isNotEmpty) {
      try {
        Uri uri = Uri.parse(urlString);
        host = uri.host.isNotEmpty ? uri.host : "local";

        var segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
        if (segments.isNotEmpty) {
          if (segments.length > 1 &&
              (segments.last.length + segments[segments.length - 2].length <
                  30)) {
            pathDetail = segments.sublist(segments.length - 2).join('-');
          } else {
            pathDetail = segments.last;
          }
        } else {
          pathDetail = "base";
        }
      } catch (e) {
        List<String> parts = urlString.split('/');
        if (parts.length > 2) {
          host = parts[2]; // Typically the host
          if (parts.length > 3 && parts.last.isNotEmpty)
            pathDetail = parts.last;
          else
            pathDetail = "path-error";
        } else {
          pathDetail = "url-parse-error";
        }
      }
    }

    host = sanitize(host);
    pathDetail = sanitize(pathDetail);

    final int maxLen = 30;
    host = host.length > maxLen ? host.substring(0, maxLen) : host;
    pathDetail = pathDetail.length > maxLen
        ? pathDetail.substring(0, maxLen)
        : pathDetail;

    String uniqueSuffix = entryId.substring(0, min(8, entryId.length));

    return "${host}_${pathDetail}_${uniqueSuffix}.json";
  }

  Future<void> _saveLogToFile(
      String entryId, Map<String, dynamic> logData) async {
    try {
      final String? homeDir =
          Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
      if (homeDir == null) {
        if (kDebugMode) {
          print('Error: Could not determine home directory.');
        }
        return;
      }

      // 使用 Platform.pathSeparator 保证跨平台兼容性，或者直接用 '/' 因为 macOS/Linux
      final directoryPath = '$homeDir/RaySystemNetworkLogs/$instanceId';
      final directory = Directory(directoryPath);

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filename = _generateFilename(logData, entryId);
      final filePath = '${directory.path}/$filename';

      final file = File(filePath);

      // 递归处理 logData，将内部的 JSON 字符串转换为 Dart 对象
      final processedLogData = _decodeAndBeautifyJsonStrings(logData);

      // 使用 JsonEncoder.withIndent 美化整个处理后的对象
      final encoder = JsonEncoder.withIndent('  ');
      final formattedJson = encoder.convert(processedLogData);

      await file.writeAsString(formattedJson);
      if (kDebugMode) {
        print('Network log saved to file: $filePath');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error saving network log to file: $e');
        print('Stack trace: $stackTrace');
      }
    }
  }

  /// 清除所有网络请求日志
  void clearNetworkLogs() {
    _networkLogs.clear();
    notifyListeners();
    if (kDebugMode) {
      print('Network logs cleared for state[$instanceId]');
    }
  }

  /// 设置开发者工具是否打开
  void setDevToolsOpen(bool isOpen) {
    if (_isDevToolsOpen != isOpen) {
      _isDevToolsOpen = isOpen;
      notifyListeners();
    }
  }
}
