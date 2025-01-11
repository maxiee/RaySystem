import 'package:flutter/widgets.dart';

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
    _cards.add(cardWidget);
    notifyListeners();
  }
}
