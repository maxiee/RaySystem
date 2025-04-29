import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/api/note_tree/note_tree_service.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_state.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/provider/note_tree_service_provider.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';

/// 管理树的基本结构的提供者
final noteTreeBaseProvider =
    AsyncNotifierProvider<NoteTreeBaseNotifier, NoteTreeBaseState>(
  () => NoteTreeBaseNotifier(),
);

class NoteTreeBaseNotifier extends AsyncNotifier<NoteTreeBaseState> {
  NoteTreeService get _treeService => ref.read(noteTreeServiceProvider);

  @override
  Future<NoteTreeBaseState> build() async {
    // 加载初始数据
    final initialItems = await _treeService.getInitialItems();
    return NoteTreeBaseState(items: initialItems);
  }

  /// 查找特定ID的节点
  NoteTreeItem? findItemById(int id) {
    if (state.value == null) return null;
    return _findItemById(state.value!.items, id);
  }

  /// 递归查找节点的辅助方法
  NoteTreeItem? _findItemById(List<NoteTreeItem> items, int id) {
    for (var item in items) {
      if (item.id == id) return item;
      if (item.children.isNotEmpty) {
        final foundInChildren = _findItemById(item.children, id);
        if (foundInChildren != null) return foundInChildren;
      }
    }
    return null;
  }

  /// 更新特定节点的子节点
  Future<void> updateNodeChildren(
      int parentId, List<NoteTreeItem> newChildren) async {
    if (state.value == null) return;

    final updatedItems = _updateNodeChildren(
        List.from(state.value!.items), parentId, newChildren);

    if (updatedItems != null) {
      state = AsyncData(state.value!.copyWith(items: updatedItems));
    }
  }

  /// 更新多个节点的子节点
  Future<void> updateMultipleNodesChildren(
      Map<int, List<NoteTreeItem>> childrenMap) async {
    if (state.value == null) return;

    final itemsAfterLoading = _updateMultipleNodesChildren(
        List.from(state.value!.items), childrenMap);

    if (!identical(itemsAfterLoading, state.value!.items)) {
      state = AsyncData(state.value!.copyWith(items: itemsAfterLoading));
    }
  }

  /// 重置缓存并刷新树的基础结构
  Future<void> refreshBaseTree() async {
    _treeService.resetCache();

    try {
      final initialItems = await _treeService.getInitialItems();
      state = AsyncData(NoteTreeBaseState(items: initialItems));
    } catch (e, s) {
      debugPrint("Error during refreshBaseTree: $e \n$s");
      state = AsyncError(e, s);
    }
  }

  // 以下是从原NoteTree移植过来的辅助方法，但现在它们被分离到适当的文件中

  /// 更新特定节点的子节点的辅助方法
  List<NoteTreeItem>? _updateNodeChildren(List<NoteTreeItem> currentItems,
      int parentId, List<NoteTreeItem> newChildren) {
    List<NoteTreeItem> updatedList = [];
    bool updated = false;
    for (var item in currentItems) {
      if (item.id == parentId) {
        // Update children, keep existing expansion state from the item itself
        updatedList.add(item.copyWith(children: newChildren));
        updated = true;
      } else if (item.children.isNotEmpty) {
        final updatedChildren =
            _updateNodeChildren(item.children, parentId, newChildren);
        if (updatedChildren != null) {
          updatedList.add(item.copyWith(children: updatedChildren));
          updated = true; // Mark as updated if a child was updated
        } else {
          updatedList.add(item);
        }
      } else {
        updatedList.add(item);
      }
    }
    return updated
        ? updatedList
        : null; // Return null if no update occurred at this level
  }

  /// 更新多个节点的子节点的辅助方法
  List<NoteTreeItem> _updateMultipleNodesChildren(
      List<NoteTreeItem> currentItems,
      Map<int, List<NoteTreeItem>> childrenMap) {
    List<NoteTreeItem> updatedList = [];
    bool changed = false;
    for (var item in currentItems) {
      NoteTreeItem updatedItem = item; // Start with the original item
      if (childrenMap.containsKey(item.id)) {
        // Update this item's children
        final newChildren =
            childrenMap[item.id]!; // Should not be null if key exists
        updatedItem = item.copyWith(
          children: newChildren,
          // Explicitly mark as folder if children were loaded for it.
          // This handles the transition from leaf node to parent node.
          isFolder: true,
        );
        changed = true; // Mark change at this level
      } else if (item.children.isNotEmpty) {
        // Recurse into existing children (if any)
        final updatedChildren =
            _updateMultipleNodesChildren(item.children, childrenMap);
        // Only copyWith if children actually changed during recursion
        if (!identical(updatedChildren, item.children)) {
          updatedItem = item.copyWith(children: updatedChildren);
          changed = true; // Mark change at this level
        }
      }
      // If neither the item itself nor its descendants were updated,
      // updatedItem remains identical to item.
      updatedList.add(updatedItem);
    }
    // Return a new list only if changes occurred, otherwise return original.
    return changed ? updatedList : currentItems;
  }
}
