import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart';
import 'package:raysystem_flutter/api/api.dart';

class SystemMetricsProvider extends ChangeNotifier {
  final DefaultApi _api = api;
  SystemMetrics? _metrics;
  Timer? _timer;
  bool _loading = false;
  String? _error;

  SystemMetrics? get metrics => _metrics;
  bool get loading => _loading;
  String? get error => _error;

  SystemMetricsProvider() {
    _startPolling();
  }

  void _startPolling() {
    // Poll every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      fetchMetrics();
    });
    // Initial fetch
    fetchMetrics();
  }

  Future<void> fetchMetrics() async {
    try {
      _loading = true;
      notifyListeners();

      final response = await _api.getMetricsSystemMetricsGet();
      // print('Response: ${response.data?.anyOf}'); // 调试信息
      if (response.data?.anyOf.values[0] != null) {
        _metrics = response.data?.anyOf.values[0] as SystemMetrics;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
