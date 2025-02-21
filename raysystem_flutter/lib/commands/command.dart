import 'package:flutter/material.dart';
import 'package:raysystem_flutter/card/card_manager.dart';

typedef CommandCallback = void Function(
    BuildContext context, CardManager cardManager);

class Command {
  final String command;
  final String title;
  final IconData icon;
  final CommandCallback? callback;
  final List<Command>? subCommands;

  const Command({
    required this.command,
    required this.title,
    required this.icon,
    this.callback,
    this.subCommands,
  });

  Map<String, dynamic> toJson() {
    return {
      'command': command,
      'title': title,
      'icon': icon,
      'callback': callback,
      if (subCommands != null)
        'commands': subCommands!.map((cmd) => cmd.toJson()).toList(),
    };
  }
}
