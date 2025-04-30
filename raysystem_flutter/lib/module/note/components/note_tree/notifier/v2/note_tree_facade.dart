import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/v2/note_tree_data_state.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/v2/note_tree_drag_drop_state.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/v2/note_tree_expansion_state.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/v2/note_tree_selection_state.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';

/// 统一的笔记树状态，组合了所有分离的状态
class NoteTreeStateV2 {
  /// 所有笔记项（ID映射）
  final Map<int, NoteTreeItem> notesMap;

  /// 父子关系映射
  final Map<int, List<int>> childrenMap;

  /// 根节点ID列表
  final List<int> rootIds;

  /// 展开的节点ID集合
  final Set<int> expandedIds;

  /// 正在加载的节点ID集合
  final Set<int> loadingIds;

  /// 当前选中的节点ID
  final int? selectedId;

  /// 正在拖动的节点ID
  final int? draggedId;

  /// 是否正在拖动
  final bool isDragging;

  /// 当前悬停的目标节点ID
  final int? hoveredId;

  /// 当前悬停目标是否有效
  final bool isHoverValid;

  const NoteTreeStateV2({
    this.notesMap = const {},
    this.childrenMap = const {},
    this.rootIds = const [],
    this.expandedIds = const {},
    this.loadingIds = const {},
    this.selectedId,
    this.draggedId,
    this.isDragging = false,
    this.hoveredId,
    this.isHoverValid = false,
  });

  /// 获取完整的树项列表（用于渲染）
  List<NoteTreeItem> get items {
    return rootIds.map((id) => notesMap[id]).whereType<NoteTreeItem>().toList();
  }

  /// 获取特定节点的所有子节点
  List<NoteTreeItem> getChildren(int parentId) {
    return childrenMap[parentId]
            ?.map((id) => notesMap[id])
            .whereType<NoteTreeItem>()
            .toList() ??
        [];
  }

  /// 获取所选节点
  NoteTreeItem? get selectedItem =>
      selectedId != null ? notesMap[selectedId] : null;

  /// 获取被拖动的节点
  NoteTreeItem? get draggedItem =>
      draggedId != null ? notesMap[draggedId] : null;
}

/// 笔记树统一状态提供者
final noteTreeStateV2Provider = Provider<AsyncValue<NoteTreeStateV2>>((ref) {
  // 监听所有底层状态提供者
  final dataState = ref.watch(noteTreeDataProvider);
  final expansionState = ref.watch(noteTreeExpansionProvider);
  final selectionState = ref.watch(noteTreeSelectionProvider);
  final dragDropState = ref.watch(noteTreeDragDropProvider);

  // 如果数据状态仍在加载中，返回加载中状态
  if (dataState is AsyncLoading) {
    return const AsyncLoading();
  }

  // 如果数据状态有错误，返回错误状态
  if (dataState is AsyncError) {
    // 使用非空断言确保类型安全
    return AsyncError(
        dataState.error as Object, dataState.stackTrace as StackTrace);
  }

  // 数据已加载，组合所有状态
  if (dataState is AsyncData && dataState.value != null) {
    return AsyncData(NoteTreeStateV2(
      notesMap: dataState.value!.notesMap,
      childrenMap: dataState.value!.childrenMap,
      rootIds: dataState.value!.rootIds,
      expandedIds: expansionState.expandedIds,
      loadingIds: expansionState.loadingIds,
      selectedId: selectionState.selectedId,
      draggedId: dragDropState.draggedId,
      isDragging: dragDropState.isDragging,
      hoveredId: dragDropState.hoveredId,
      isHoverValid: dragDropState.isHoverValid,
    ));
  }

  // 默认返回加载中状态
  return const AsyncLoading();
});

/// 笔记树控制器，提供所有操作方法的统一接口
class NoteTreeControllerV2 {
  final Ref ref;

  NoteTreeControllerV2(this.ref);

  // 数据操作
  Future<void> refreshTree() =>
      ref.read(noteTreeDataProvider.notifier).refreshTree();

  Future<int?> addChildNote(int parentId, String title, String content) => ref
      .read(noteTreeDataProvider.notifier)
      .addChildNote(parentId, title, content);

  Future<bool> deleteNote(int noteId) =>
      ref.read(noteTreeDataProvider.notifier).deleteNote(noteId);

  // 选择操作
  void selectNote(int noteId) =>
      ref.read(noteTreeSelectionProvider.notifier).selectNote(noteId);

  void clearSelection() =>
      ref.read(noteTreeSelectionProvider.notifier).clearSelection();

  // 展开操作
  Future<void> toggleExpand(int noteId) =>
      ref.read(noteTreeExpansionProvider.notifier).toggleExpand(noteId);

  Future<void> ensureExpanded(Set<int> noteIds) =>
      ref.read(noteTreeExpansionProvider.notifier).ensureExpanded(noteIds);

  // 拖放操作
  void startDrag(int noteId) =>
      ref.read(noteTreeDragDropProvider.notifier).startDrag(noteId);

  void endDrag() => ref.read(noteTreeDragDropProvider.notifier).endDrag();

  Future<void> hoverTarget(int targetId) =>
      ref.read(noteTreeDragDropProvider.notifier).hoverTarget(targetId);

  void leaveTarget() =>
      ref.read(noteTreeDragDropProvider.notifier).leaveTarget();

  Future<bool> moveNote() =>
      ref.read(noteTreeDragDropProvider.notifier).moveNote();

  // 查找项目
  NoteTreeItem? findItemById(int id) =>
      ref.read(noteTreeDataProvider).value?.findItemById(id);
}

/// 笔记树控制器提供者
final noteTreeControllerV2Provider = Provider((ref) {
  return NoteTreeControllerV2(ref);
});
