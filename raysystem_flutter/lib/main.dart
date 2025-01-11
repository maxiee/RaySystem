import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_list_view.dart';
import 'package:raysystem_flutter/card/card_manager.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => CardManager(maxCards: 20), child: const MyApp()));
}

enum InteractionLevel { level1, level2 }

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
    switch (_currentLevel) {
      case InteractionLevel.level1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedApp = 'notes';
                  _currentLevel = InteractionLevel.level2;
                });
              },
              child: const Text('笔记'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedApp = 'todos';
                  _currentLevel = InteractionLevel.level2;
                });
              },
              child: const Text('待办事项'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedApp = 'news';
                  _currentLevel = InteractionLevel.level2;
                });
              },
              child: const Text('资讯'),
            ),
          ],
        );
      case InteractionLevel.level2:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('当前应用: $_selectedApp'),
            ElevatedButton(
              onPressed: () {
                final cardManager =
                    Provider.of<CardManager>(context, listen: false);
                cardManager
                    .addCard(MySampleCard(uniqueId: DateTime.now().toString()));
              },
              child: const Text('添加卡片'),
            ),
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
