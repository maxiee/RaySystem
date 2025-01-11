import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_list_view.dart';
import 'package:raysystem_flutter/card/card_manager.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => CardManager(maxCards: 20), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream-like Card Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('流式卡片 Demo'),
        ),
        body: Column(
          children: [
            Expanded(
              child: const CardListView(),
            ),
            // 底部添加按钮，测试插入新卡片
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // 从全局 CardManager 获取并添加新卡片
                  final cardManager =
                      Provider.of<CardManager>(context, listen: false);

                  cardManager.addCard(MySampleCard(
                      key: UniqueKey(), uniqueId: DateTime.now().toString()));
                },
                child: const Text('添加一个新卡片'),
              ),
            ),
          ],
        ),
      ),
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
