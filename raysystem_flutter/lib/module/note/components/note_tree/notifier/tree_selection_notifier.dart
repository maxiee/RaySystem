import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_state.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';

/// 管理树节点选择的提供者
final noteTreeSelectionProvider =
    NotifierProvider<NoteTreeSelectionNotifier, NoteTreeSelectionState>(
  () => NoteTreeSelectionNotifier(),
);

class NoteTreeSelectionNotifier extends Notifier<NoteTreeSelectionState> {
  @override
  NoteTreeSelectionState build() {
    return const NoteTreeSelectionState();
  }

  /// 选择一个节点
  void selectItem(NoteTreeItem item) {
    state = state.copyWith(selectedItem: item);
  }

  /// 清除选择
  void clearSelection() {
    state = state.copyWith(clearSelectedItem: true);
  }

  /// 如果被删除的项目是当前选中项，则清除选择
  void handleItemDeleted(int itemId) {
    if (state.selectedItem?.id == itemId) {
      clearSelection();
    }
  }
}
