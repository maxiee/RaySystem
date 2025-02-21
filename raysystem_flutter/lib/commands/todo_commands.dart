import 'package:flutter/material.dart';
import 'package:raysystem_flutter/commands/command.dart';

final todoCommands = Command(
  command: 'todo-app',
  title: '待办事项应用',
  icon: Icons.check,
  subCommands: [
    Command(
      command: 'todo-add',
      title: '添加待办事项',
      icon: Icons.add,
      callback: (context, cardManager) {
        print('添加待办事项');
      },
    ),
    Command(
      command: 'todo-list',
      title: '查看待办事项',
      icon: Icons.list,
      callback: (context, cardManager) {
        print('查看待办事项');
      },
    ),
    Command(
      command: 'todo-delete',
      title: '删除待办事项',
      icon: Icons.delete,
      callback: (context, cardManager) {
        print('删除待办事项');
      },
    ),
    Command(
      command: 'todo-more',
      title: '更多操作',
      icon: Icons.more_horiz,
      subCommands: [
        Command(
          command: 'todo-more-1',
          title: '更多操作1',
          icon: Icons.more_horiz,
          callback: (context, cardManager) {
            print('更多操作1');
          },
        ),
        Command(
          command: 'todo-more-2',
          title: '更多操作2',
          icon: Icons.more_horiz,
          callback: (context, cardManager) {
            print('更多操作2');
          },
        ),
      ],
    ),
  ],
);
