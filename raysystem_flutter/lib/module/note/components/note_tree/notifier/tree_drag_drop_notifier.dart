import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:raysystem_flutter/api/api_provider.dart';
import 'package:raysystem_flutter/module/note/api/note_tree/note_tree_service.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_base_notifier.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_expansion_notifier.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_facade.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_state.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/provider/note_tree_service_provider.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';

/// 管理树节点拖放操作的提供者
final noteTreeDragDropProvider =
    NotifierProvider<NoteTreeDragDropNotifier, NoteTreeDragDropState>(
  () => NoteTreeDragDropNotifier(),
);

class NoteTreeDragDropNotifier extends Notifier<NoteTreeDragDropState> {
  NotesApi get _notesApi => ref.read(notesApiProvider);
  NoteTreeService get _treeService => ref.read(noteTreeServiceProvider);

  @override
  NoteTreeDragDropState build() {
    return const NoteTreeDragDropState();
  }

  /// 开始拖动操作
  void startDrag(NoteTreeItem item) {
    state = state.copyWith(draggedItem: item, isDragging: true);
  }

  /// 结束拖动操作
  void endDrag() {
    state = state.copyWith(
        clearDraggedItem: true, isDragging: false, clearHoverState: true);
  }

  /// 当悬停在潜在目标上时调用
  Future<void> hoverTarget(NoteTreeItem targetItem) async {
    final dragged = state.draggedItem;
    if (dragged == null) return;

    bool isValid = true;
    // 1. 不能拖放到自身
    if (targetItem.id == dragged.id) {
      isValid = false;
    } else {
      // 2. 不能拖放到后代节点
      bool isDescendant = await _isDescendantOf(targetItem.id, dragged.id);
      if (isDescendant) {
        isValid = false;
      }
      // 3. 只能拖放到文件夹（可选规则，根据需要实现）
      // if (!targetItem.isFolder) {
      //   isValid = false;
      // }
    }

    // 更新状态，包含悬停目标ID和有效性
    state = state.copyWith(
      hoveredTargetId: targetItem.id,
      isHoverTargetValid: isValid,
    );
  }

  /// 当离开潜在目标时调用
  void leaveTarget() {
    state = state.copyWith(clearHoverState: true);
  }

  /// 检查一个节点是否是另一个节点的后代
  Future<bool> _isDescendantOf(int itemId, int potentialAncestorId) async {
    // 优化：如果 potentialAncestorId 不是文件夹，则它不可能是祖先
    // 这需要获取祖先项目（如果尚未可用），可能很复杂。
    // 暂时保留API调用。
    try {
      final response =
          await _notesApi.getNotePathNotesNoteIdPathGet(noteId: itemId);
      // 检查路径中的任何节点（不包括项目本身）是否与潜在祖先匹配
      return response.data?.any(
              (note) => note.id == potentialAncestorId && note.id != itemId) ??
          false;
    } catch (e) {
      debugPrint('Error checking ancestry: $e');
      return true; // 出错时假设为后代，以防止无效拖放
    }
  }

  /// 移动笔记
  Future<bool> moveNote(NoteTreeItem targetItem) async {
    final dragged = state.draggedItem;
    if (dragged == null ||
        state.hoveredTargetId != targetItem.id ||
        !state.isHoverTargetValid) {
      endDrag();
      return false;
    }

    Set<int>? ensureTargetExpanded;
    // 如果目标是文件夹，确保其标记为展开
    if (targetItem.isFolder) {
      ensureTargetExpanded = {targetItem.id};
    }

    try {
      await _notesApi.moveNoteNotesNoteIdMovePost(
        noteId: dragged.id,
        newParentId: targetItem.id,
      );
      _treeService.resetCache(); // 重置服务缓存

      // 刷新树，保留展开状态并确保目标已展开
      final facadeNotifier = ref.read(noteTreeFacadeProvider.notifier);
      await facadeNotifier.refreshTree(
          preserveExpansion: true, ensureExpanded: ensureTargetExpanded);

      // endDrag() 通过 refreshTree 设置新状态隐式调用
      return true;
    } catch (e) {
      debugPrint('Error moving note: $e');
      // 即使出错也刷新，保留展开状态以保持一致性
      final facadeNotifier = ref.read(noteTreeFacadeProvider.notifier);
      await facadeNotifier.refreshTree(
          preserveExpansion: true, ensureExpanded: ensureTargetExpanded);
      // endDrag() 隐式调用
      return false;
    }
  }
}
