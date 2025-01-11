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
  ]
};

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<List<Map<String, dynamic>>> _commandStack = [];

  @override
  void initState() {
    super.initState();
    _commandStack.add(commands['commands']);
  }

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
    if (_commandStack.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentCommands = _commandStack.last;
    if (currentCommands == null || currentCommands is! List) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...currentCommands.map((cmd) {
          if (cmd is! Map<String, dynamic>) return const SizedBox.shrink();
          return ElevatedButton(
            onPressed: () {
              if (cmd.containsKey('commands')) {
                final List<dynamic>? subCmds = cmd['commands'];
                if (subCmds != null) {
                  setState(() {
                    _commandStack.add(List<Map<String, dynamic>>.from(subCmds));
                  });
                }
              } else if (cmd['callback'] != null) {
                cmd['callback']();
              }
            },
            child: Text(cmd['title']?.toString() ?? '无标题'),
          );
        }).toList(),
        if (_commandStack.length > 1)
          ElevatedButton(
            onPressed: () {
              setState(() {
                _commandStack.removeLast();
              });
            },
            child: const Text('返回'),
          ),
      ],
    );
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
