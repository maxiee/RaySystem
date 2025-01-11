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
        body: const Column(
          children: [
            Expanded(
              child: CardListView(),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  final cardManager =
                      Provider.of<CardManager>(context, listen: false);
                  cardManager.addCard(
                      MySampleCard(uniqueId: DateTime.now().toString()));
                },
                child: const Text('添加卡片'),
              ),
              ElevatedButton(
                onPressed: () {
                  // final cardManager =
                  //     Provider.of<CardManager>(context, listen: false);
                  // cardManager.clearCards();
                },
                child: const Text('清空列表'),
              ),
            ],
          ),
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
