import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_list_view.dart';
import 'package:raysystem_flutter/card/card_manager.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => CardManager(maxCards: 20), child: const MyApp()));
}

enum InteractionLevel { level1, level2 }

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
          commands: [
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
  ]
};

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  InteractionLevel _currentLevel = InteractionLevel.level1;
  String _selectedApp = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream-like Card Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('流式卡片 Demo'),
        ),
        body: const Column(
          children: [
            Expanded(
              child: CardListView(),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomPanel(context),
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    if (_currentLevel == InteractionLevel.level1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: commands.keys.map((appKey) {
          return ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedApp = appKey;
                _currentLevel = InteractionLevel.level2;
              });
            },
            child:
                Text(appKey), // Use the appKey (e.g. 'notes', 'todos', 'news')
          );
        }).toList(),
      );
    } else {
      final appCommands = commands[_selectedApp] ?? {};
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('当前应用: $_selectedApp'),
          ...appCommands.entries.map((entry) {
            final cmdTitle = entry.value['title'];
            final cmdCallback = entry.value['callback'];
            return ElevatedButton(
              onPressed: () => cmdCallback(),
              child: Text(cmdTitle),
            );
          }).toList(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentLevel = InteractionLevel.level1;
              });
            },
            child: const Text('返回'),
          ),
        ],
      );
    }
  }
}

class MySampleCard extends StatefulWidget {
  final String uniqueId;
  const MySampleCard({super.key, required this.uniqueId});

  @override
  State<MySampleCard> createState() => _MySampleCardState();
}

class _MySampleCardState extends State<MySampleCard> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Card ID: ${widget.uniqueId}'),
      subtitle: Text('当前计数: $_counter'),
      onTap: () {
        setState(() {
          _counter++;
        });
      },
    );
  }
}
