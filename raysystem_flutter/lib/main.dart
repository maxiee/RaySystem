import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_list_view.dart';
import 'package:raysystem_flutter/card/card_manager.dart';
import 'package:raysystem_flutter/commands.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => CardManager(maxCards: 20), child: const MyApp()));
}

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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ...currentCommands.map((cmd) {
          return ElevatedButton.icon(
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
            icon: Icon(cmd['icon'] as IconData?),
            label: Text(cmd['title']?.toString() ?? '无标题'),
          );
        }),
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
