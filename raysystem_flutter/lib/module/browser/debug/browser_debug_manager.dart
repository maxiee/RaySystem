import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'browser_debug_state.dart';

/// 管理所有浏览器实例的调试状态的单例类
class BrowserDebugManager with ChangeNotifier {
  // 单例模式实现
  BrowserDebugManager._();
  static final BrowserDebugManager _instance = BrowserDebugManager._();
  static BrowserDebugManager get instance => _instance;

  // 存储所有浏览器实例的调试状态
  final Map<String, BrowserDebugState> _debugStates = {};
  // 当前活跃的实例ID
  String? _activeInstanceId;

  // 获取所有实例的调试状态
  List<BrowserDebugState> get allDebugStates => _debugStates.values.toList();

  // 获取当前活跃的调试状态
  BrowserDebugState? get activeDebugState {
    return _activeInstanceId != null ? _debugStates[_activeInstanceId] : null;
  }

  // 根据ID获取调试状态
  BrowserDebugState? getDebugState(String instanceId) {
    return _debugStates[instanceId];
  }

  // 注册一个新的浏览器实例
  String registerBrowserInstance(String title) {
    final instanceId = const Uuid().v4();
    final debugState = BrowserDebugState(
      instanceId: instanceId,
      title: title,
    );
    _debugStates[instanceId] = debugState;

    // 如果是第一个实例，自动设为活跃实例
    if (_activeInstanceId == null) {
      _activeInstanceId = instanceId;
    }

    notifyListeners();
    if (kDebugMode) {
      print('Registered browser instance: $instanceId ($title)');
    }
    return instanceId;
  }

  // 反注册一个浏览器实例
  void unregisterBrowserInstance(String instanceId) {
    if (_debugStates.containsKey(instanceId)) {
      _debugStates.remove(instanceId);

      // 如果移除的是当前活跃实例，重新选择活跃实例
      if (_activeInstanceId == instanceId) {
        _activeInstanceId =
            _debugStates.isNotEmpty ? _debugStates.keys.first : null;
      }

      notifyListeners();
      if (kDebugMode) {
        print('Unregistered browser instance: $instanceId');
      }
    }
  }

  // 设置当前活跃的调试实例
  void setActiveInstance(String instanceId) {
    if (_debugStates.containsKey(instanceId) &&
        _activeInstanceId != instanceId) {
      _activeInstanceId = instanceId;
      notifyListeners();
      if (kDebugMode) {
        print('Active browser instance changed to: $instanceId');
      }
    }
  }

  // 更新浏览器实例的标题
  void updateInstanceTitle(String instanceId, String newTitle) {
    if (_debugStates.containsKey(instanceId)) {
      // 由于BrowserDebugState的title是final，我们需要创建一个新实例并保留其他数据
      final oldState = _debugStates[instanceId]!;
      final newState = BrowserDebugState(
        instanceId: instanceId,
        title: newTitle,
      );

      // 在这里可以添加更多需要复制的状态
      // ...

      _debugStates[instanceId] = newState;
      notifyListeners();
      if (kDebugMode) {
        print('Updated browser instance title: $instanceId -> $newTitle');
      }
    }
  }
}
