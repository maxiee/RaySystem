import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/commands/command.dart';
import 'package:raysystem_flutter/main.dart';

final settingsCommands = Command(
  command: 'settings-app',
  title: '设置',
  icon: Icons.settings,
  subCommands: [
    Command(
      command: 'toggle-theme',
      title: '切换主题',
      icon: Icons.brightness_medium,
      callback: (context, cardManager) {
        final themeNotifier =
            Provider.of<ThemeNotifier>(context, listen: false);
        themeNotifier.toggleTheme();
      },
    ),
  ],
);
