import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';
import 'package:raysystem_flutter/card/card_manager.dart';

Map<String, dynamic> commands = {
  'commands': [
    {
      'command': 'note-app',
      'title': '笔记应用',
      'icon': Icons.note,
      'commands': [
        {
          'command': 'note-add',
          'title': '添加笔记',
          'icon': Icons.add,
          'callback': (BuildContext context, CardManager cardManager) {
            print('添加笔记');
          }
        },
        {
          'command': 'note-list',
          'title': '查看笔记',
          'icon': Icons.list,
          'callback': (BuildContext context, CardManager cardManager) {
            print('查看笔记');
          }
        },
        {
          'command': 'note-delete',
          'title': '删除笔记',
          'icon': Icons.delete,
          'callback': (BuildContext context, CardManager cardManager) {
            print('删除笔记');
          }
        }
      ]
    },
    {
      'command': 'todo-app',
      'title': '待办事项应用',
      'icon': Icons.check,
      'commands': [
        {
          'command': 'todo-add',
          'title': '添加待办事项',
          'icon': Icons.add,
          'callback': (BuildContext context, CardManager cardManager) {
            print('添加待办事项');
          }
        },
        {
          'command': 'todo-list',
          'title': '查看待办事项',
          'icon': Icons.list,
          'callback': (BuildContext context, CardManager cardManager) {
            print('查看待办事项');
          }
        },
        {
          'command': 'todo-delete',
          'title': '删除待办事项',
          'icon': Icons.delete,
          'callback': (BuildContext context, CardManager cardManager) {
            print('删除待办事项');
          }
        },
        {
          'command': 'todo-more',
          'title': '更多操作',
          'icon': Icons.more_horiz,
          'commands': [
            {
              'command': 'todo-more-1',
              'title': '更多操作1',
              'icon': Icons.more_horiz,
              'callback': (BuildContext context, CardManager cardManager) {
                print('更多操作1');
              }
            },
            {
              'command': 'todo-more-2',
              'title': '更多操作2',
              'icon': Icons.more_horiz,
              'callback': (BuildContext context, CardManager cardManager) {
                print('更多操作2');
              }
            }
          ]
        }
      ]
    },
    {
      'command': 'playground-app',
      'title': '游乐场',
      'icon': Icons.play_arrow,
      'commands': [
        {
          'command': 'digital-clock',
          'title': '数字时钟',
          'icon': Icons.watch_later,
          'callback': (BuildContext context, CardManager cardManager) {
            print('数字时钟');
            cardManager.addCard(DigitalClock(
              isLive: true,
            ));
          }
        },
        {
          'command': 'analog-clock',
          'title': '模拟时钟',
          'icon': Icons.watch,
          'callback': (BuildContext context, CardManager cardManager) {
            print('模拟时钟');
            cardManager.addCard(AnalogClock(
              width: 200,
              height: 200,
              isLive: true,
            ));
          }
        }
      ]
    }
  ]
};
