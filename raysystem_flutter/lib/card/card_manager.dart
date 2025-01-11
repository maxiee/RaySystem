import 'package:flutter/widgets.dart';
import 'package:raysystem_flutter/card/card_item.dart';

class CardManager with ChangeNotifier {
  final List<CardItem> _cards = [];
  final int _maxCards;

  CardManager({int maxCards = 20}) : _maxCards = maxCards;

  List<CardItem> get cards => List.unmodifiable(_cards);

  // 添加新卡片
  void addCard(Widget Function(GlobalKey key) builder) {
    if (_cards.length >= _maxCards) {
      // 移除最早的一条
      _cards.removeAt(0);
    }
    final newKey = GlobalKey();
    _cards.add(CardItem(key: newKey, builder: builder));
    notifyListeners();
  }

  // 移除指定卡片
  void removeCard(CardItem item) {
    _cards.remove(item);
    notifyListeners();
  }
}
