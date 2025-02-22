import 'package:flutter/material.dart';
import 'package:raysystem_flutter/commands/command.dart';
import 'package:raysystem_flutter/commands/settings_commands.dart';
import 'package:raysystem_flutter/commands/text_commands.dart';
import 'package:raysystem_flutter/commands/note_commands.dart';
import 'package:raysystem_flutter/commands/todo_commands.dart';
import 'package:raysystem_flutter/commands/playground_commands.dart';
import 'package:raysystem_flutter/commands/info_commands.dart';
import 'package:raysystem_flutter/commands/scheduler_commands.dart';

final List<Command> rootCommands = [
  settingsCommands,
  textCommands,
  noteCommands,
  todoCommands,
  playgroundCommands,
  infoCommands,
  schedulerCommands,
];

Map<String, dynamic> get commands => {
      'commands': rootCommands.map((cmd) => cmd.toJson()).toList(),
    };
