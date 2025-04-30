import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/v2/note_tree_data_state.dart';

/// 管理笔记树拖放状态的状态类
class NoteTreeDragDropState {
  /// 当前被拖动的笔记ID
  final int? draggedId;

  /// 是否正在拖动
  final bool isDragging;

  /// 当前悬停的目标ID
  final int? hoveredId;

  /// 当前悬停目标是否有效
  final bool isHoverValid;

  const NoteTreeDragDropState({
    this.draggedId,
    this.isDragging = false,
    this.hoveredId,
    this.isHoverValid = false,
  });

  /// 创建状态副本
  NoteTreeDragDropState copyWith({
    int? draggedId,
    bool? isDragging,
    int? hoveredId,
    bool? isHoverValid,
    bool clearDragState = false,
    bool clearHoverState = false,
  }) {
    return NoteTreeDragDropState(
      draggedId: clearDragState ? null : draggedId ?? this.draggedId,
      isDragging: clearDragState ? false : isDragging ?? this.isDragging,
      hoveredId: clearHoverState ? null : hoveredId ?? this.hoveredId,
      isHoverValid: clearHoverState ? false : isHoverValid ?? this.isHoverValid,
    );
  }
}

/// 管理笔记树拖放状态的Provider
final noteTreeDragDropProvider =
    NotifierProvider<NoteTreeDragDropNotifier, NoteTreeDragDropState>(
  () => NoteTreeDragDropNotifier(),
);

class NoteTreeDragDropNotifier extends Notifier<NoteTreeDragDropState> {
  @override
  NoteTreeDragDropState build() {
    return const NoteTreeDragDropState();
  }

  /// 开始拖动操作
  void startDrag(int noteId) {
    state = state.copyWith(
        draggedId: noteId, isDragging: true, clearHoverState: true);
  }

  /// 结束拖动操作
  void endDrag() {
    state = state.copyWith(clearDragState: true, clearHoverState: true);
  }

  /// 悬停在潜在的放置目标上
  Future<void> hoverTarget(int targetId) async {
    if (!state.isDragging || state.draggedId == null) return;

    final draggedId = state.draggedId!;
    bool isValid = true;

    // 检查拖放规则
    final dataState = ref.read(noteTreeDataProvider).value;
    if (dataState == null) return;

    // 规则1: 不能拖放到自己身上
    if (targetId == draggedId) {
      isValid = false;
    }
    // 规则2: 不能拖放到自己的后代上（会造成循环引用）
    else if (dataState.isDescendantOf(targetId, draggedId)) {
      isValid = false;
    }
    // 可以添加更多规则...

    state = state.copyWith(hoveredId: targetId, isHoverValid: isValid);
  }

  /// 离开放置目标
  void leaveTarget() {
    state = state.copyWith(clearHoverState: true);
  }

  /// 执行笔记移动操作
  Future<bool> moveNote() async {
    final dataNotifier = ref.read(noteTreeDataProvider.notifier);

    // 检查拖放状态是否有效
    if (!state.isDragging ||
        state.draggedId == null ||
        state.hoveredId == null ||
        !state.isHoverValid) {
      endDrag();
      return false;
    }

    final draggedId = state.draggedId!;
    final targetId = state.hoveredId!;

    try {
      // 执行移动操作
      final success = await dataNotifier.moveNote(draggedId, targetId);

      // 无论成功与否都结束拖拽操作
      endDrag();

      return success;
    } catch (e) {
      debugPrint("Error during drag and drop: $e");
      endDrag();
      return false;
    }
  }
}
