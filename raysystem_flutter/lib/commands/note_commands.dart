import 'package:flutter/material.dart';
import 'package:raysystem_flutter/commands/command.dart';

final noteCommands = Command(
  command: 'note-app',
  title: '笔记应用',
  icon: Icons.note,
  subCommands: [
    Command(
      command: 'note-add',
      title: '添加笔记',
      icon: Icons.add,
      callback: (context, cardManager) {
        print('添加笔记');
      },
    ),
    Command(
      command: 'note-list',
      title: '查看笔记',
      icon: Icons.list,
      callback: (context, cardManager) {
        print('查看笔记');
      },
    ),
    Command(
      command: 'note-delete',
      title: '删除笔记',
      icon: Icons.delete,
      callback: (context, cardManager) {
        print('删除笔记');
      },
    ),
  ],
);
