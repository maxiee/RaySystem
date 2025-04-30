import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/v2/note_tree_data_state.dart';

/// 管理笔记树选择状态的状态类
class NoteTreeSelectionState {
  /// 当前选中的笔记ID
  final int? selectedId;

  const NoteTreeSelectionState({
    this.selectedId,
  });

  /// 创建状态副本
  NoteTreeSelectionState copyWith({
    int? selectedId,
    bool clearSelection = false,
  }) {
    return NoteTreeSelectionState(
      selectedId: clearSelection ? null : selectedId ?? this.selectedId,
    );
  }

  /// 检查笔记是否被选中
  bool isSelected(int id) => selectedId == id;
}

/// 管理笔记树选择状态的Provider
final noteTreeSelectionProvider =
    NotifierProvider<NoteTreeSelectionNotifier, NoteTreeSelectionState>(
  () => NoteTreeSelectionNotifier(),
);

class NoteTreeSelectionNotifier extends Notifier<NoteTreeSelectionState> {
  @override
  NoteTreeSelectionState build() {
    return const NoteTreeSelectionState();
  }

  /// 选择笔记
  void selectNote(int noteId) {
    state = state.copyWith(selectedId: noteId);
  }

  /// 清除选择
  void clearSelection() {
    state = state.copyWith(clearSelection: true);
  }

  /// 处理笔记删除事件
  void handleNoteDeleted(int noteId) {
    if (state.selectedId == noteId) {
      clearSelection();
    }
  }

  /// 保存当前选择状态
  int? saveSelectionState() {
    return state.selectedId;
  }

  /// 恢复之前保存的选择状态
  void restoreSelectionState(int? savedId) {
    if (savedId == null) {
      clearSelection();
    } else {
      // 验证该ID是否仍然存在
      final dataState = ref.read(noteTreeDataProvider).value;
      if (dataState != null && dataState.findItemById(savedId) != null) {
        state = state.copyWith(selectedId: savedId);
      } else {
        clearSelection();
      }
    }
  }
}
