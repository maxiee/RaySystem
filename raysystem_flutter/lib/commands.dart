import 'package:flutter/material.dart';

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
          'callback': () {
            print('添加笔记');
          }
        },
        {
          'command': 'note-list',
          'title': '查看笔记',
          'icon': Icons.list,
          'callback': () {
            print('查看笔记');
          }
        },
        {
          'command': 'note-delete',
          'title': '删除笔记',
          'icon': Icons.delete,
          'callback': () {
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
          'callback': () {
            print('添加待办事项');
          }
        },
        {
          'command': 'todo-list',
          'title': '查看待办事项',
          'icon': Icons.list,
          'callback': () {
            print('查看待办事项');
          }
        },
        {
          'command': 'todo-delete',
          'title': '删除待办事项',
          'icon': Icons.delete,
          'callback': () {
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
              'callback': () {
                print('更多操作1');
              }
            },
            {
              'command': 'todo-more-2',
              'title': '更多操作2',
              'icon': Icons.more_horiz,
              'callback': () {
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
          'command': 'led-clock',
          'title': 'LED 时钟',
          'icon': Icons.watch_later,
          'callback': () {
            print('LED 时钟');
          }
        }
      ]
    }
  ]
};
