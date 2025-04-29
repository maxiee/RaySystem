import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/api/note_tree/note_tree_service.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_base_notifier.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_crud_notifier.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_drag_drop_notifier.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_expansion_notifier.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_selection_notifier.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_state.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/provider/note_tree_service_provider.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';

/// 一个统一的提供者，将所有分离的功能结合起来，与原始的NoteTree API兼容
final noteTreeFacadeProvider =
    AsyncNotifierProvider<NoteTreeFacade, NoteTreeState>(
  () => NoteTreeFacade(),
);

/// 外观类，整合所有拆分的功能，保持与原始API的兼容性
class NoteTreeFacade extends AsyncNotifier<NoteTreeState> {
  NoteTreeService get _treeService => ref.read(noteTreeServiceProvider);

  @override
  Future<NoteTreeState> build() async {
    // 监听所有基础提供者以自动重建外观状态
    ref.watch(noteTreeBaseProvider);
    ref.watch(noteTreeSelectionProvider);
    ref.watch(noteTreeExpansionProvider);
    ref.watch(noteTreeDragDropProvider);

    // 合并当前状态
    return _combineCurrentState();
  }

  /// 从各个部分合并当前状态
  NoteTreeState _combineCurrentState() {
    final baseState =
        ref.read(noteTreeBaseProvider).value ?? const NoteTreeBaseState();
    final selectionState = ref.read(noteTreeSelectionProvider);
    final expansionState = ref.read(noteTreeExpansionProvider);
    final dragDropState = ref.read(noteTreeDragDropProvider);

    return NoteTreeState.fromBase(
      baseState,
      selectionState: selectionState,
      expansionState: expansionState,
      dragDropState: dragDropState,
    );
  }

  /// 选择项目 - 委托给选择提供者
  void selectItem(NoteTreeItem item) {
    ref.read(noteTreeSelectionProvider.notifier).selectItem(item);
  }

  /// 切换展开 - 委托给展开提供者
  Future<void> toggleExpand(NoteTreeItem item) async {
    await ref.read(noteTreeExpansionProvider.notifier).toggleExpand(item);
  }

  /// 开始拖动 - 委托给拖放提供者
  void startDrag(NoteTreeItem item) {
    ref.read(noteTreeDragDropProvider.notifier).startDrag(item);
  }

  /// 结束拖动 - 委托给拖放提供者
  void endDrag() {
    ref.read(noteTreeDragDropProvider.notifier).endDrag();
  }

  /// 悬停目标 - 委托给拖放提供者
  Future<void> hoverTarget(NoteTreeItem targetItem) async {
    await ref.read(noteTreeDragDropProvider.notifier).hoverTarget(targetItem);
  }

  /// 离开目标 - 委托给拖放提供者
  void leaveTarget() {
    ref.read(noteTreeDragDropProvider.notifier).leaveTarget();
  }

  /// 移动笔记 - 委托给拖放提供者
  Future<bool> moveNote(NoteTreeItem targetItem) async {
    return await ref
        .read(noteTreeDragDropProvider.notifier)
        .moveNote(targetItem);
  }

  /// 添加子笔记 - 委托给CRUD提供者
  Future<int?> addChildNote(NoteTreeItem parentItem, String title) async {
    return await ref
        .read(noteTreeCrudProvider.notifier)
        .addChildNote(parentItem, title);
  }

  /// 删除笔记 - 委托给CRUD提供者
  Future<bool> deleteNote(NoteTreeItem item) async {
    return await ref.read(noteTreeCrudProvider.notifier).deleteNote(item);
  }

  /// 刷新树 - 综合操作，协调多个提供者
  Future<void> refreshTree(
      {bool preserveExpansion = false, Set<int>? ensureExpanded}) async {
    // 捕获当前状态细节
    final currentExpandedIds = preserveExpansion
        ? Set<int>.from(ref.read(noteTreeExpansionProvider).expandedFolderIds)
        : <int>{};

    if (ensureExpanded != null) {
      currentExpandedIds.addAll(ensureExpanded);
    }

    final currentSelectedId =
        ref.read(noteTreeSelectionProvider).selectedItem?.id;

    // 重置缓存
    _treeService.resetCache();

    try {
      // 刷新基础树结构
      final baseNotifier = ref.read(noteTreeBaseProvider.notifier);
      await baseNotifier.refreshBaseTree();

      // 如果需要保留展开状态，加载必要的子节点
      if (currentExpandedIds.isNotEmpty) {
        // 更新展开状态
        final expansionNotifier = ref.read(noteTreeExpansionProvider.notifier);

        // 这里不直接更新状态，因为loadExpandedFolders会处理
        await expansionNotifier.loadExpandedFolders(currentExpandedIds);
      }

      // 恢复选择
      if (currentSelectedId != null) {
        final baseState = ref.read(noteTreeBaseProvider).value;
        if (baseState != null) {
          final baseNotifier = ref.read(noteTreeBaseProvider.notifier);
          final finalSelectedItem =
              baseNotifier.findItemById(currentSelectedId);

          if (finalSelectedItem != null) {
            final selectionNotifier =
                ref.read(noteTreeSelectionProvider.notifier);
            selectionNotifier.selectItem(finalSelectedItem);
          } else {
            final selectionNotifier =
                ref.read(noteTreeSelectionProvider.notifier);
            selectionNotifier.clearSelection();
          }
        }
      }

      // 恢复状态后清除拖放状态
      final dragDropNotifier = ref.read(noteTreeDragDropProvider.notifier);
      dragDropNotifier.endDrag();
    } catch (e, s) {
      debugPrint("Error during refreshTree: $e \n$s");
      state = AsyncError(e, s);
    }
  }

  /// 查找项目 - 委托给基础提供者
  NoteTreeItem? findItemById(int id) {
    final baseNotifier = ref.read(noteTreeBaseProvider.notifier);
    return baseNotifier.findItemById(id);
  }
}
