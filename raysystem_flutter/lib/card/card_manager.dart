import 'package:flutter/material.dart';
import 'package:raysystem_flutter/card/card_list_view.dart';

class CardManager with ChangeNotifier {
  final List<Widget> _cards = [];
  final int _maxCards;
  // 存储 key 到卡片索引的映射，用于快速查找
  final Map<Key, int> _keyToIndexMap = {};

  CardManager({int maxCards = 20}) : _maxCards = maxCards;

  List<Widget> get cards => List.unmodifiable(_cards);

  // 添加新卡片
  void addCard(
    Widget cardContent, {
    Widget? title,
    List<Widget>? leadingActions,
    List<Widget>? trailingActions,
    List<Widget>? footerActions,
    Color? color,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? elevation,
  }) {
    if (_cards.length >= _maxCards) {
      // 移除最早的一条，同时也要更新映射
      final firstCardWidget = _cards[0];
      // 找到第一张卡片的 key
      final firstCardKey = _findKeyInWidget(firstCardWidget);
      if (firstCardKey != null) {
        _keyToIndexMap.remove(firstCardKey);
      }
      _cards.removeAt(0);
      // 更新所有剩余卡片的索引
      _updateIndices();
    }

    // 使用 UniqueKey 确保卡片在列表中的唯一性
    final cardKey = UniqueKey();

    // 创建带关闭按钮的 trailingActions
    final List<Widget> allTrailingActions = [
      // 添加 macOS 风格的关闭按钮（红色圆形）
      MacOSCloseButton(
        onPressed: () => removeCardByKey(cardKey),
      ),
      // 如果有其他 trailingActions，则添加它们
      if (trailingActions != null) ...trailingActions,
    ];

    // 使用 RepaintBoundary 提高性能并防止不必要的重绘
    final card = RepaintBoundary(
      key: cardKey,
      child: SizedBox(
        width: double.infinity,
        child: RayCard(
          content: cardContent,
          title: title,
          leadingActions: leadingActions,
          trailingActions: allTrailingActions,
          footerActions: footerActions,
          color: color,
          padding: padding,
          margin: margin,
          elevation: elevation,
        ),
      ),
    );

    _cards.add(card);
    // 存储 key 到索引的映射
    _keyToIndexMap[cardKey] = _cards.length - 1;

    notifyListeners();
  }

  // 根据索引移除卡片
  void removeCard(int index) {
    if (index >= 0 && index < _cards.length) {
      final cardWidget = _cards[index];
      final cardKey = _findKeyInWidget(cardWidget);
      if (cardKey != null) {
        _keyToIndexMap.remove(cardKey);
      }
      _cards.removeAt(index);
      // 更新索引映射
      _updateIndices();
      notifyListeners();
    }
  }

  // 根据 key 移除卡片
  void removeCardByKey(Key key) {
    final index = _keyToIndexMap[key];
    if (index != null) {
      _cards.removeAt(index);
      _keyToIndexMap.remove(key);
      // 更新索引映射
      _updateIndices();
      notifyListeners();
    }
  }

  // 清空所有卡片
  void clearCards() {
    _cards.clear();
    _keyToIndexMap.clear();
    notifyListeners();
  }

  // 获取当前卡片数量
  int get cardCount => _cards.length;

  // 更新所有卡片的索引映射
  void _updateIndices() {
    for (int i = 0; i < _cards.length; i++) {
      final key = _findKeyInWidget(_cards[i]);
      if (key != null) {
        _keyToIndexMap[key] = i;
      }
    }
  }

  // 在 Widget 中查找 key
  Key? _findKeyInWidget(Widget widget) {
    return widget.key;
  }
}

/// macOS 风格的关闭按钮（红色圆形）
class MacOSCloseButton extends StatefulWidget {
  final VoidCallback onPressed;

  const MacOSCloseButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<MacOSCloseButton> createState() => _MacOSCloseButtonState();
}

class _MacOSCloseButtonState extends State<MacOSCloseButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: _isHovered ? Colors.red.shade700 : Colors.red,
            shape: BoxShape.circle,
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 1,
                      spreadRadius: 0.5,
                    )
                  ]
                : null,
          ),
          child: _isHovered
              ? const Icon(
                  Icons.close,
                  size: 10,
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}
