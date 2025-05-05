import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/component/card/ray_card.dart';
import 'browser_debug_manager.dart';
import 'browser_debug_state.dart';

/// 一个标签页定义
class DevToolsTab {
  final String title;
  final IconData icon;
  final Widget Function(BuildContext context, String instanceId) contentBuilder;

  DevToolsTab({
    required this.title,
    required this.icon,
    required this.contentBuilder,
  });
}

/// 浏览器开发者工具卡片，支持多个标签页切换
class BrowserDevToolsCard extends StatefulWidget {
  final String? instanceId; // 如果提供了实例ID，则直接关联到该浏览器实例

  const BrowserDevToolsCard({
    super.key,
    this.instanceId,
  });

  @override
  State<BrowserDevToolsCard> createState() => _BrowserDevToolsCardState();
}

class _BrowserDevToolsCardState extends State<BrowserDevToolsCard> {
  late String _activeInstanceId;
  int _selectedTabIndex = 0;

  // 定义所有可用的标签页
  final List<DevToolsTab> _tabs = [
    DevToolsTab(
      title: '网络请求',
      icon: Icons.wifi,
      contentBuilder: (context, instanceId) =>
          NetworkRequestsTab(instanceId: instanceId),
    ),
    // 将来可以添加更多标签页
    // DevToolsTab(
    //   title: 'Console',
    //   icon: Icons.code,
    //   contentBuilder: (context, instanceId) => ConsoleTab(instanceId: instanceId),
    // ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeInstanceId();
  }

  void _initializeInstanceId() {
    if (widget.instanceId != null) {
      _activeInstanceId = widget.instanceId!;
    } else {
      // 如果没有传入实例ID，则使用第一个可用的实例
      final allStates = BrowserDebugManager.instance.allDebugStates;
      if (allStates.isNotEmpty) {
        _activeInstanceId = allStates.first.instanceId;
      } else {
        // 如果没有可用实例，则创建一个占位符ID，后续可以修改
        _activeInstanceId = 'no-instance-available';
      }
    }
  }

  void _changeInstanceId(String newInstanceId) {
    setState(() {
      _activeInstanceId = newInstanceId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RayCard(
      title: Text('开发者工具'),
      trailingActions: [
        // 浏览器实例选择器
        _buildInstanceSelector(),
      ],
      content: Column(
        children: [
          // 标签页选择器
          _buildTabBar(),
          // 标签页内容
          Expanded(
            child: _tabs[_selectedTabIndex]
                .contentBuilder(context, _activeInstanceId),
          ),
        ],
      ),
    );
  }

  Widget _buildInstanceSelector() {
    final allInstances = BrowserDebugManager.instance.allDebugStates;

    return DropdownButton<String>(
      value: allInstances.any((state) => state.instanceId == _activeInstanceId)
          ? _activeInstanceId
          : (allInstances.isNotEmpty ? allInstances.first.instanceId : null),
      onChanged: (String? newValue) {
        if (newValue != null) {
          _changeInstanceId(newValue);
        }
      },
      items:
          allInstances.map<DropdownMenuItem<String>>((BrowserDebugState state) {
        return DropdownMenuItem<String>(
          value: state.instanceId,
          child: Text(state.title.isEmpty ? '未命名浏览器' : state.title,
              style: TextStyle(fontSize: 14)),
        );
      }).toList(),
      icon: const Icon(Icons.arrow_drop_down, size: 16),
      underline: Container(), // 移除下划线
      isDense: true,
      hint: const Text('选择浏览器实例'),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border:
            Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final tab = _tabs[index];
          final isSelected = index == _selectedTabIndex;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedTabIndex = index;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tab.icon,
                    size: 16,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tab.title,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 网络请求标签页
class NetworkRequestsTab extends StatelessWidget {
  final String instanceId;

  const NetworkRequestsTab({
    super.key,
    required this.instanceId,
  });

  @override
  Widget build(BuildContext context) {
    // 通过 ChangeNotifierProvider 监听当前实例的网络日志变化
    return ChangeNotifierProvider.value(
      value: BrowserDebugManager.instance.getDebugState(instanceId) ??
          BrowserDebugState(instanceId: 'dummy', title: '未找到实例'),
      child: Consumer<BrowserDebugState>(
        builder: (context, debugState, child) {
          final networkLogs = debugState.networkLogs;

          if (networkLogs.isEmpty) {
            return const Center(
              child: Text('暂无网络请求日志。在浏览器中请访问网页以捕获网络请求。'),
            );
          }

          return Column(
            children: [
              // 工具栏
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('清除'),
                      onPressed: () {
                        debugState.clearNetworkLogs();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        textStyle: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('已捕获 ${networkLogs.length} 个请求'),
                    const Spacer(),
                    // 这里可以添加过滤器、搜索框等
                  ],
                ),
              ),

              // 网络请求列表
              Expanded(
                child: ListView.builder(
                  itemCount: networkLogs.length,
                  itemBuilder: (context, index) {
                    // 倒序显示，最新的请求在上面
                    final logEntry =
                        networkLogs[networkLogs.length - 1 - index];
                    final logData = logEntry.data;

                    // 解析请求数据
                    final method = logData['method'] ?? 'GET';
                    final url = logData['url'] ?? 'Unknown URL';
                    final status = logData['status']?.toString() ?? 'pending';
                    final contentType = logData['contentType'] ?? 'unknown';
                    final timestamp = logEntry.timestamp;

                    // 根据状态码设置颜色
                    Color statusColor;
                    if (status == 'pending') {
                      statusColor = Colors.orange;
                    } else {
                      final statusCode = int.tryParse(status) ?? 0;
                      if (statusCode >= 200 && statusCode < 300) {
                        statusColor = Colors.green;
                      } else if (statusCode >= 300 && statusCode < 400) {
                        statusColor = Colors.blue;
                      } else {
                        statusColor = Colors.red;
                      }
                    }

                    return ListTile(
                      dense: true,
                      title: Text(
                        url.toString().length > 50
                            ? '${url.toString().substring(0, 50)}...'
                            : url.toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.blueGrey.shade800
                                  : Colors.blueGrey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              method,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 10,
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            contentType,
                            style: const TextStyle(fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Text(
                            '${timestamp.hour}:${timestamp.minute}:${timestamp.second}',
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      onTap: () {
                        // 点击请求时，显示详细信息
                        _showNetworkRequestDetails(context, logEntry);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showNetworkRequestDetails(
      BuildContext context, NetworkLogEntry logEntry) {
    final logData = logEntry.data;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('请求详情: ${logData['url']}'),
          content: SizedBox(
            width: 600,
            height: 400,
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: '概览'),
                      Tab(text: '请求头'),
                      Tab(text: '请求体'),
                      Tab(text: '响应'),
                    ],
                    labelColor: Colors.blue,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // 概览
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(
                                  '请求方式', logData['method'] ?? 'N/A'),
                              _buildDetailRow('URL', logData['url'] ?? 'N/A'),
                              _buildDetailRow('状态',
                                  logData['status']?.toString() ?? 'pending'),
                              _buildDetailRow(
                                  '内容类型', logData['contentType'] ?? 'N/A'),
                              _buildDetailRow(
                                  '时间', logEntry.timestamp.toString()),
                            ],
                          ),
                        ),
                        // 请求头
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (logData['requestHeaders'] != null)
                                for (var entry in (logData['requestHeaders']
                                        as Map<String, dynamic>)
                                    .entries)
                                  _buildDetailRow(
                                      entry.key, entry.value.toString()),
                              if (logData['requestHeaders'] == null)
                                const Text('无请求头信息'),
                            ],
                          ),
                        ),
                        // 请求体
                        SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                logData['requestBody']?.toString() ?? '无请求体'),
                          ),
                        ),
                        // 响应
                        SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                logData['responseBody']?.toString() ?? '无响应体'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('关闭'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
