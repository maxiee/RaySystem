import 'package:flutter/material.dart';
import 'package:raysystem_flutter/commands/command.dart';
import 'package:raysystem_flutter/commands/settings_commands.dart';
import 'package:raysystem_flutter/commands/text_commands.dart';
import 'package:raysystem_flutter/commands/note_commands.dart';
import 'package:raysystem_flutter/commands/todo_commands.dart';
import 'package:raysystem_flutter/commands/playground_commands.dart';
import 'package:raysystem_flutter/commands/info_commands.dart';
import 'package:raysystem_flutter/commands/scheduler_commands.dart';
import 'package:raysystem_flutter/commands/llm_commands.dart';
import 'package:raysystem_flutter/module/browser/browser_commands.dart';

final List<Command> rootCommands = [
  browserCommands,
  noteCommands,
  llmCommands,
  textCommands,
  todoCommands,
  infoCommands,
  schedulerCommands,
  playgroundCommands,
  settingsCommands,
];

Map<String, dynamic> get commands => {
      'commands': rootCommands.map((cmd) => cmd.toJson()).toList(),
    };
