import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/component/card/ray_card.dart';
import '../browser_window/browser_window.dart';
import '../../debug/browser_debug_manager.dart';
import '../../debug/browser_dev_tools_card.dart';
import 'package:raysystem_flutter/card/card_manager.dart';

class BrowserCard extends StatefulWidget {
  const BrowserCard({super.key});

  @override
  State<BrowserCard> createState() => _BrowserCardState();
}

class _BrowserCardState extends State<BrowserCard> {
  String _pageTitle = '';
  late String _instanceId;
  bool _devToolsOpen = false;
  late BrowserWindow _browserWindow;

  @override
  void initState() {
    super.initState();
    // 注册浏览器实例到调试管理器
    _instanceId = BrowserDebugManager.instance
        .registerBrowserInstance(_pageTitle.isNotEmpty ? _pageTitle : '浏览器');
  }

  @override
  void dispose() {
    // 清理浏览器实例
    BrowserDebugManager.instance.unregisterBrowserInstance(_instanceId);
    super.dispose();
  }

  void _onTitleChanged(String title) {
    setState(() {
      _pageTitle = title;
    });
    // 更新调试管理器中的标题
    BrowserDebugManager.instance.updateInstanceTitle(_instanceId, title);
  }

  void _toggleDevTools() {
    final cardManager = Provider.of<CardManager>(context, listen: false);

    if (!_devToolsOpen) {
      // 打开开发者工具
      cardManager.addCard(
        BrowserDevToolsCard(instanceId: _instanceId),
        wrappedInRayCard: false,
      );
      setState(() {
        _devToolsOpen = true;
      });
    } else {
      // 这里暂时不做关闭操作，因为我们不直接跟踪开发者工具卡片的引用
      // 用户可以通过卡片上的关闭按钮关闭
      setState(() {
        _devToolsOpen = false;
      });
    }

    // 同时更新调试状态中的开发者工具状态
    final debugState = BrowserDebugManager.instance.getDebugState(_instanceId);
    if (debugState != null) {
      debugState.setDevToolsOpen(!_devToolsOpen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RayCard(
      title: _pageTitle.isNotEmpty ? Text(_pageTitle) : const Text('浏览器'),
      trailingActions: [
        // 添加开发者工具按钮
        IconButton(
          icon: const Icon(Icons.bug_report),
          tooltip: '开发者工具',
          onPressed: _toggleDevTools,
        ),
      ],
      content: BrowserWindow(
        initialUrl: 'https://weibo.com',
        onTitleChanged: _onTitleChanged,
        instanceId: _instanceId,
      ),
    );
  }
}
