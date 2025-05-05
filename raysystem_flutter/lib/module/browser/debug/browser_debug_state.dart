import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

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
