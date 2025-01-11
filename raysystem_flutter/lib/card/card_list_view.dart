import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_manager.dart';

class CardListView extends StatelessWidget {
  const CardListView({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取全局的 CardManager
    final cardManager = Provider.of<CardManager>(context);

    return ListView.builder(
      itemCount: cardManager.cards.length,
      itemBuilder: (context, index) {
        final cardItem = cardManager.cards[index];
        // 通过 cardItem.builder(...) 动态生成卡片，并传入对应的 GlobalKey
        return Card(
          key: cardItem.key, // 这非常关键，告诉 Flutter 这个卡片应该保留对应的 State
          child: cardItem.builder(cardItem.key),
        );
      },
    );
  }
}
