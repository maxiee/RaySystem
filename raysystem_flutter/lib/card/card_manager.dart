import 'package:flutter/material.dart';
import 'package:raysystem_flutter/card/card_list_view.dart';
import 'package:raysystem_flutter/component/card/ray_card.dart';
import 'package:raysystem_flutter/component/widgets/mac_os_close_button.dart';

// 支持 1~4 列
const int kMinCardColumns = 1;
const int kMaxCardColumns = 4;

class CardManager with ChangeNotifier {
  final int _maxCardsPerColumn;
  int _columnCount = 1; // 当前列数，1~4
  int _activeColumnIndex = 0;

  // 多列卡片和 key->index 映射
  final List<List<Widget>> _columns = List.generate(kMaxCardColumns, (_) => []);
  final List<Map<Key, int>> _keyToIndexMaps =
      List.generate(kMaxCardColumns, (_) => {});

  CardManager({int maxCardsPerColumn = 20})
      : _maxCardsPerColumn = maxCardsPerColumn;

  int get columnCount => _columnCount;
  int get activeColumnIndex => _activeColumnIndex;

  // 获取每一列的卡片（只暴露当前列数内的）
  List<List<Widget>> get columns =>
      List.generate(_columnCount, (i) => List.unmodifiable(_columns[i]));

  // 兼容旧接口
  List<Widget> get leftCards => columns[0];
  List<Widget> get rightCards => _columnCount > 1 ? columns[1] : [];

  // 设置列数（1~4）
  void setColumnCount(int count) {
    if (count < kMinCardColumns || count > kMaxCardColumns) return;
    if (_columnCount != count) {
      _columnCount = count;
      if (_activeColumnIndex >= _columnCount) {
        _activeColumnIndex = 0;
      }
      notifyListeners();
    }
  }

  // 设置活跃列
  void setActiveColumn(int index) {
    if (index >= 0 && index < _columnCount && _activeColumnIndex != index) {
      _activeColumnIndex = index;
      notifyListeners();
    }
  }

  // 查找 key 所在列和索引
  ({int columnIndex, int index})? _findKeyLocation(Key key) {
    for (int i = 0; i < _columnCount; i++) {
      if (_keyToIndexMaps[i].containsKey(key)) {
        return (columnIndex: i, index: _keyToIndexMaps[i][key]!);
      }
    }
    return null;
  }

  // 添加新卡片，默认加到活跃列
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
    final targetList = _columns[_activeColumnIndex];
    final targetMap = _keyToIndexMaps[_activeColumnIndex];
    final currentColumnIndex = _activeColumnIndex;

    if (targetList.length >= _maxCardsPerColumn) {
      final firstCardWidget = targetList[0];
      final firstCardKey = _findKeyInWidget(firstCardWidget);
      if (firstCardKey != null) {
        targetMap.remove(firstCardKey);
      }
      targetList.removeAt(0);
      _updateIndices(currentColumnIndex);
    }

    final cardKey = UniqueKey();
    final List<Widget> allTrailingActions = [
      MacOSCloseButton(
        onPressed: () => removeCardByKey(cardKey),
      ),
      if (trailingActions != null) ...trailingActions,
    ];
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
    targetMap[cardKey] = targetList.length - 1;
    notifyListeners();
  }

  // 根据索引移除卡片
  void removeCard(int index, int columnIndex) {
    if (columnIndex < 0 || columnIndex >= _columnCount) return;
    final targetList = _columns[columnIndex];
    final targetMap = _keyToIndexMaps[columnIndex];
    if (index >= 0 && index < targetList.length) {
      final cardWidget = targetList[index];
      final cardKey = _findKeyInWidget(cardWidget);
      if (cardKey != null) {
        targetMap.remove(cardKey);
      }
      targetList.removeAt(index);
      _updateIndices(columnIndex);
      notifyListeners();
    }
  }

  // 根据 key 移除卡片
  void removeCardByKey(Key key) {
    final location = _findKeyLocation(key);
    if (location != null) {
      final targetList = _columns[location.columnIndex];
      final targetMap = _keyToIndexMaps[location.columnIndex];
      targetList.removeAt(location.index);
      targetMap.remove(key);
      _updateIndices(location.columnIndex);
      notifyListeners();
    }
  }

  // 清空所有卡片
  void clearCards() {
    for (var col in _columns) {
      col.clear();
    }
    for (var map in _keyToIndexMaps) {
      map.clear();
    }
    notifyListeners();
  }

  // 获取当前卡片总数
  int get cardCount =>
      _columns.take(_columnCount).fold(0, (sum, col) => sum + col.length);

  // 更新某列的 key->index 映射
  void _updateIndices(int columnIndex) {
    final targetList = _columns[columnIndex];
    final targetMap = _keyToIndexMaps[columnIndex];
    targetMap.clear();
    for (int i = 0; i < targetList.length; i++) {
      final key = _findKeyInWidget(targetList[i]);
      if (key != null) {
        targetMap[key] = i;
      }
    }
  }

  Key? _findKeyInWidget(Widget widget) {
    return widget.key;
  }
}
