import 'package:flutter/material.dart';
import 'package:raysystem_flutter/commands/command.dart';
import 'package:raysystem_flutter/module/browser/component/browser_card/browser_card.dart';
import 'package:raysystem_flutter/module/browser/debug/browser_dev_tools_card.dart';

final browserCommands = Command(
    command: 'browser-app',
    title: '网上冲浪',
    icon: Icons.language,
    subCommands: [
      Command(
        command: 'weibo-card',
        title: '刷微博',
        icon: Icons.bookmark,
        callback: (context, cardManager) {
          cardManager.addCard(const BrowserCard(), wrappedInRayCard: false);
        },
      ),
      Command(
        command: 'devtools',
        title: '浏览器开发工具',
        icon: Icons.bug_report,
        callback: (context, cardManager) {
          cardManager.addCard(const BrowserDevToolsCard(),
              wrappedInRayCard: false);
        },
      ),
    ]);
