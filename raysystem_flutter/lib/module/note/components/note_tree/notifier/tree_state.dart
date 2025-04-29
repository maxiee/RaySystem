import 'package:flutter/foundation.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';

/// 基础树状态，仅包含树的核心结构数据
class NoteTreeBaseState {
  final List<NoteTreeItem> items;

  const NoteTreeBaseState({
    this.items = const [],
  });

  NoteTreeBaseState copyWith({
    List<NoteTreeItem>? items,
  }) {
    return NoteTreeBaseState(
      items: items ?? this.items,
    );
  }
}

/// 选择状态
class NoteTreeSelectionState {
  final NoteTreeItem? selectedItem;

  const NoteTreeSelectionState({
    this.selectedItem,
  });

  NoteTreeSelectionState copyWith({
    NoteTreeItem? selectedItem,
    bool clearSelectedItem = false,
  }) {
    return NoteTreeSelectionState(
      selectedItem:
          clearSelectedItem ? null : selectedItem ?? this.selectedItem,
    );
  }
}

/// 展开状态
class NoteTreeExpansionState {
  final Set<int> expandedFolderIds;
  final Set<int> loadingFolderIds;

  const NoteTreeExpansionState({
    this.expandedFolderIds = const {},
    this.loadingFolderIds = const {},
  });

  NoteTreeExpansionState copyWith({
    Set<int>? expandedFolderIds,
    Set<int>? loadingFolderIds,
  }) {
    return NoteTreeExpansionState(
      expandedFolderIds: expandedFolderIds ?? this.expandedFolderIds,
      loadingFolderIds: loadingFolderIds ?? this.loadingFolderIds,
    );
  }
}

/// 拖放状态
class NoteTreeDragDropState {
  final NoteTreeItem? draggedItem;
  final bool isDragging;
  final int? hoveredTargetId;
  final bool isHoverTargetValid;

  const NoteTreeDragDropState({
    this.draggedItem,
    this.isDragging = false,
    this.hoveredTargetId,
    this.isHoverTargetValid = false,
  });

  NoteTreeDragDropState copyWith({
    NoteTreeItem? draggedItem,
    bool? isDragging,
    int? hoveredTargetId,
    bool? isHoverTargetValid,
    bool clearDraggedItem = false,
    bool clearHoverState = false,
  }) {
    return NoteTreeDragDropState(
      draggedItem: clearDraggedItem ? null : draggedItem ?? this.draggedItem,
      isDragging: isDragging ?? this.isDragging,
      hoveredTargetId:
          clearHoverState ? null : hoveredTargetId ?? this.hoveredTargetId,
      isHoverTargetValid: clearHoverState
          ? false
          : isHoverTargetValid ?? this.isHoverTargetValid,
    );
  }
}

/// 完整的树状态，组合了所有分离的状态
class NoteTreeState {
  final List<NoteTreeItem> items;
  final NoteTreeItem? selectedItem;
  final NoteTreeItem? draggedItem;
  final bool isDragging;
  final Set<int> expandedFolderIds;
  final Set<int> loadingFolderIds;
  final int? hoveredTargetId;
  final bool isHoverTargetValid;

  const NoteTreeState({
    this.items = const [],
    this.selectedItem,
    this.draggedItem,
    this.isDragging = false,
    this.expandedFolderIds = const {},
    this.loadingFolderIds = const {},
    this.hoveredTargetId,
    this.isHoverTargetValid = false,
  });

  /// 从基础状态创建
  NoteTreeState.fromBase(
    NoteTreeBaseState baseState, {
    NoteTreeSelectionState? selectionState,
    NoteTreeExpansionState? expansionState,
    NoteTreeDragDropState? dragDropState,
  })  : items = baseState.items,
        selectedItem = selectionState?.selectedItem,
        draggedItem = dragDropState?.draggedItem,
        isDragging = dragDropState?.isDragging ?? false,
        expandedFolderIds = expansionState?.expandedFolderIds ?? {},
        loadingFolderIds = expansionState?.loadingFolderIds ?? {},
        hoveredTargetId = dragDropState?.hoveredTargetId,
        isHoverTargetValid = dragDropState?.isHoverTargetValid ?? false;

  /// 提取基础状态
  NoteTreeBaseState get baseState => NoteTreeBaseState(items: items);

  /// 提取选择状态
  NoteTreeSelectionState get selectionState =>
      NoteTreeSelectionState(selectedItem: selectedItem);

  /// 提取展开状态
  NoteTreeExpansionState get expansionState => NoteTreeExpansionState(
      expandedFolderIds: expandedFolderIds, loadingFolderIds: loadingFolderIds);

  /// 提取拖放状态
  NoteTreeDragDropState get dragDropState => NoteTreeDragDropState(
        draggedItem: draggedItem,
        isDragging: isDragging,
        hoveredTargetId: hoveredTargetId,
        isHoverTargetValid: isHoverTargetValid,
      );

  NoteTreeState copyWith({
    List<NoteTreeItem>? items,
    NoteTreeItem? selectedItem,
    NoteTreeItem? draggedItem,
    bool? isDragging,
    Set<int>? expandedFolderIds,
    Set<int>? loadingFolderIds,
    int? hoveredTargetId,
    bool? isHoverTargetValid,
    bool clearSelectedItem = false,
    bool clearDraggedItem = false,
    bool clearHoverState = false,
  }) {
    return NoteTreeState(
      items: items ?? this.items,
      selectedItem:
          clearSelectedItem ? null : selectedItem ?? this.selectedItem,
      draggedItem: clearDraggedItem ? null : draggedItem ?? this.draggedItem,
      isDragging: isDragging ?? this.isDragging,
      expandedFolderIds: expandedFolderIds ?? this.expandedFolderIds,
      loadingFolderIds: loadingFolderIds ?? this.loadingFolderIds,
      hoveredTargetId:
          clearHoverState ? null : hoveredTargetId ?? this.hoveredTargetId,
      isHoverTargetValid: clearHoverState
          ? false
          : isHoverTargetValid ?? this.isHoverTargetValid,
    );
  }
}
