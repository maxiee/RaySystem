import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';

part 'note_tree_state.freezed.dart';

/// 笔记树的核心数据结构
@freezed
abstract class NoteTreeState with _$NoteTreeState {
  const factory NoteTreeState({
    NoteTreeItem? selectedItem,

    /// 所有已知笔记的映射，以ID为键
    @Default({}) Map<int, NoteTreeItem> notesMap,

    /// 父子关系映射，键为父ID，值为子ID列表
    @Default({}) Map<int, List<int>> childrenMap,

    /// 根笔记ID列表（没有父笔记的笔记）
    @Default([]) List<int> rootIds,

    /// 展开状态
    @Default({}) Set<int> expandedFolderIds,

    /// 加载状态
    @Default({}) Set<int> loadingFolderIds,
  }) = _NoteTreeState;
}
