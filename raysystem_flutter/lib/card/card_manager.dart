import 'package:flutter/material.dart';
import 'package:raysystem_flutter/card/card_list_view.dart';

// Define layout modes
enum CardLayoutMode { singleColumn, dualColumn }

class CardManager with ChangeNotifier {
  // Use two lists for dual columns
  final List<Widget> _leftCards = [];
  final List<Widget> _rightCards = [];

  final int _maxCardsPerColumn;
  // 存储 key 到卡片索引的映射，用于快速查找
  // Maps for key to index lookup per column
  final Map<Key, int> _leftKeyToIndexMap = {};
  final Map<Key, int> _rightKeyToIndexMap = {};

  // Layout and active column state
  CardLayoutMode _layoutMode = CardLayoutMode.singleColumn;
  int _activeColumnIndex = 0; // 0 for left, 1 for right

  CardManager({int maxCardsPerColumn = 20})
      : _maxCardsPerColumn = maxCardsPerColumn;

  // Getters for layout and active column
  CardLayoutMode get layoutMode => _layoutMode;
  int get activeColumnIndex => _activeColumnIndex;

  // Getters for card lists (unmodifiable)
  List<Widget> get leftCards => List.unmodifiable(_leftCards);
  List<Widget> get rightCards => List.unmodifiable(_rightCards);

  // Set layout mode
  void setLayoutMode(CardLayoutMode mode) {
    if (_layoutMode != mode) {
      _layoutMode = mode;
      // Reset active column to left when switching modes? Or keep it?
      // Let's reset to left when switching to dual, keep it otherwise.
      if (_layoutMode == CardLayoutMode.dualColumn) {
        _activeColumnIndex = 0;
      } else {
        _activeColumnIndex = 0; // Always 0 in single column mode
      }
      notifyListeners();
    }
  }

  // Set active column (only relevant in dual column mode)
  void setActiveColumn(int index) {
    if (_layoutMode == CardLayoutMode.dualColumn &&
        _activeColumnIndex != index &&
        (index == 0 || index == 1)) {
      _activeColumnIndex = index;
      notifyListeners();
    }
  }

  // Find key location (which column and index)
  ({int columnIndex, int index})? _findKeyLocation(Key key) {
    if (_leftKeyToIndexMap.containsKey(key)) {
      return (columnIndex: 0, index: _leftKeyToIndexMap[key]!);
    }
    if (_rightKeyToIndexMap.containsKey(key)) {
      return (columnIndex: 1, index: _rightKeyToIndexMap[key]!);
    }
    return null;
  }

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
    final targetList =
        (_layoutMode == CardLayoutMode.singleColumn || _activeColumnIndex == 0)
            ? _leftCards
            : _rightCards;
    final targetMap =
        (_layoutMode == CardLayoutMode.singleColumn || _activeColumnIndex == 0)
            ? _leftKeyToIndexMap
            : _rightKeyToIndexMap;
    final currentColumnIndex =
        (_layoutMode == CardLayoutMode.singleColumn || _activeColumnIndex == 0)
            ? 0
            : 1;

    // Apply max card limit per column
    if (targetList.length >= _maxCardsPerColumn) {
      // 移除最早的一条，同时也要更新映射
      final firstCardWidget = targetList[0];
      // 找到第一张卡片的 key
      final firstCardKey = _findKeyInWidget(firstCardWidget);
      if (firstCardKey != null) {
        targetMap.remove(firstCardKey);
      }
      targetList.removeAt(0);
      // 更新所有剩余卡片的索引
      _updateIndices(currentColumnIndex);
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

    targetList.add(card);
    // 存储 key 到索引的映射
    targetMap[cardKey] = targetList.length - 1;

    notifyListeners();
  }

  // 根据索引移除卡片
  void removeCard(int index, int columnIndex) {
    if (columnIndex != 0 && columnIndex != 1) return; // Invalid column

    final targetList = columnIndex == 0 ? _leftCards : _rightCards;
    final targetMap =
        columnIndex == 0 ? _leftKeyToIndexMap : _rightKeyToIndexMap;

    if (index >= 0 && index < targetList.length) {
      final cardWidget = targetList[index];
      final cardKey = _findKeyInWidget(cardWidget);
      if (cardKey != null) {
        targetMap.remove(cardKey);
      }
      targetList.removeAt(index);
      _updateIndices(columnIndex); // Update indices for the affected column
      notifyListeners();
    }
  }

  // 根据 key 移除卡片
  void removeCardByKey(Key key) {
    final location = _findKeyLocation(key);

    if (location != null) {
      final targetList = location.columnIndex == 0 ? _leftCards : _rightCards;
      final targetMap =
          location.columnIndex == 0 ? _leftKeyToIndexMap : _rightKeyToIndexMap;

      targetList.removeAt(location.index);
      targetMap.remove(key);
      _updateIndices(
          location.columnIndex); // Update indices for the affected column
      notifyListeners();
    }
  }

  // 清空所有卡片
  void clearCards() {
    _leftCards.clear();
    _rightCards.clear();
    _leftKeyToIndexMap.clear();
    _rightKeyToIndexMap.clear();
    notifyListeners();
  }

  // 获取当前卡片数量
  int get cardCount => _leftCards.length + _rightCards.length;

  // 更新所有卡片的索引映射
  void _updateIndices(int columnIndex) {
    final targetList = columnIndex == 0 ? _leftCards : _rightCards;
    final targetMap =
        columnIndex == 0 ? _leftKeyToIndexMap : _rightKeyToIndexMap;
    targetMap.clear(); // Clear and rebuild map for the column
    for (int i = 0; i < targetList.length; i++) {
      final key = _findKeyInWidget(targetList[i]);
      if (key != null) {
        targetMap[key] = i;
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
