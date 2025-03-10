import 'package:flutter/material.dart';

class CardManager with ChangeNotifier {
  final List<Widget> _cards = [];
  final int _maxCards;

  CardManager({int maxCards = 20}) : _maxCards = maxCards;

  List<Widget> get cards => List.unmodifiable(_cards);

  // 添加新卡片
  void addCard(Widget cardWidget) {
    if (_cards.length >= _maxCards) {
      // 移除最早的一条
      _cards.removeAt(0);
    }

    // 使用 RepaintBoundary 提高性能并防止不必要的重绘
    // 使用 UniqueKey 确保卡片在列表中的唯一性
    _cards.add(
      RepaintBoundary(
        child: Card(
          key: UniqueKey(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(width: double.infinity, child: cardWidget),
          ),
        ),
      ),
    );

    notifyListeners();
  }

  // 移除特定位置的卡片
  void removeCard(int index) {
    if (index >= 0 && index < _cards.length) {
      _cards.removeAt(index);
      notifyListeners();
    }
  }

  // 清空所有卡片
  void clearCards() {
    _cards.clear();
    notifyListeners();
  }

  // 获取当前卡片数量
  int get cardCount => _cards.length;
}
