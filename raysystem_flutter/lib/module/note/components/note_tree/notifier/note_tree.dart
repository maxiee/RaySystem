// filepath: /Volumes/ssd/Code/RaySystem/raysystem_flutter/lib/module/note/components/note_tree/notifier/note_tree.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_facade.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_state.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// 保持与原始API兼容的提供者，但内部使用新的拆分架构
final noteTreeProvider = AsyncNotifierProvider<NoteTree, NoteTreeState>(
  () => NoteTree(),
);

/// 兼容层，保持与原始NoteTree API兼容，但内部委托给分离的功能模块
class NoteTree extends AsyncNotifier<NoteTreeState> {
  @override
  Future<NoteTreeState> build() async {
    // 监听外观提供者，自动更新状态
    final facadeState = await ref.watch(noteTreeFacadeProvider.future);
    return facadeState;
  }

  // --- Selection ---
  void selectItem(NoteTreeItem item) =>
      ref.read(noteTreeFacadeProvider.notifier).selectItem(item);

  // --- Expansion ---
  Future<void> toggleExpand(NoteTreeItem item) =>
      ref.read(noteTreeFacadeProvider.notifier).toggleExpand(item);

  // --- Drag and Drop ---
  void startDrag(NoteTreeItem item) =>
      ref.read(noteTreeFacadeProvider.notifier).startDrag(item);
  void endDrag() => ref.read(noteTreeFacadeProvider.notifier).endDrag();
  Future<void> hoverTarget(NoteTreeItem targetItem) =>
      ref.read(noteTreeFacadeProvider.notifier).hoverTarget(targetItem);
  void leaveTarget() => ref.read(noteTreeFacadeProvider.notifier).leaveTarget();
  Future<bool> moveNote(NoteTreeItem targetItem) =>
      ref.read(noteTreeFacadeProvider.notifier).moveNote(targetItem);

  // --- CRUD Operations ---
  Future<int?> addChildNote(NoteTreeItem parentItem, String title) =>
      ref.read(noteTreeFacadeProvider.notifier).addChildNote(parentItem, title);
  Future<bool> deleteNote(NoteTreeItem item) =>
      ref.read(noteTreeFacadeProvider.notifier).deleteNote(item);

  // --- Refreshing ---
  Future<void> refreshTree(
          {bool preserveExpansion = false, Set<int>? ensureExpanded}) =>
      ref.read(noteTreeFacadeProvider.notifier).refreshTree(
          preserveExpansion: preserveExpansion, ensureExpanded: ensureExpanded);

  // --- Helper methods ---
  NoteTreeItem? _findItemById(List<NoteTreeItem> items, int id) =>
      ref.read(noteTreeFacadeProvider.notifier).findItemById(id);

  // 下面的方法保持原有的签名，但委托给新架构中的对应方法
  Future<void> _loadChildrenAndUpdateState(int parentId) async {
    // 这个方法在新架构中由 toggleExpand 内部处理
    await toggleExpand(
        NoteTreeItem(id: parentId, name: "临时名称", isFolder: true));
  }

  List<NoteTreeItem>? _updateNodeChildren(List<NoteTreeItem> currentItems,
      int parentId, List<NoteTreeItem> newChildren) {
    // 这个方法在新架构中由 TreeBaseNotifier 处理
    // 我们在这里提供一个实现，以保持API兼容性，但它实际上不会被调用
    return null;
  }

  Future<bool> _isDescendantOf(int itemId, int potentialAncestorId) async {
    // 这个方法在新架构中由 TreeDragDropNotifier 处理
    // 提供一个实现以保持API兼容性
    return false;
  }

  Future<NoteTreeState> _recursivelyLoadChildrenForState(
      NoteTreeState currentState, Set<int> expandedIdsToLoad) async {
    // 这个方法在新架构中由 TreeFacade 和 TreeExpansionNotifier 处理
    // 提供一个实现以保持API兼容性
    return currentState;
  }

  void _findFoldersToLoadRecursive(
      List<NoteTreeItem> items, Set<int> expandedIds, List<int> foldersToLoad) {
    // 这个方法在新架构中由 TreeExpansionNotifier 处理
    // 提供一个实现以保持API兼容性
  }

  List<NoteTreeItem> _updateMultipleNodesChildren(
      List<NoteTreeItem> currentItems,
      Map<int, List<NoteTreeItem>> childrenMap) {
    // 这个方法在新架构中由 TreeBaseNotifier 处理
    // 提供一个实现以保持API兼容性
    return currentItems;
  }
}
