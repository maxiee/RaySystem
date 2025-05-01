import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/new/base/note_tree_state.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';

final noteTreeProvider = StateNotifierProvider<NoteTreeProvider, NoteTreeState>(
    (ref) => NoteTreeProvider(NoteTreeState()));

/// 笔记树的核心数据结构
class NoteTreeProvider extends StateNotifier<NoteTreeState> {
  NoteTreeProvider(super.state);

  void resetCache() {
    state = NoteTreeState();
  }

  void setSelectedItem(NoteTreeItem item) {
    state = state.copyWith(selectedItem: item);
  }

  List<NoteTreeItem> getRootItems() {
    return state.rootIds
        .map((id) => state.notesMap[id])
        .whereType<NoteTreeItem>()
        .toList();
  }

  void addNote(NoteTreeItem newNote, {int? parentId}) {
    final updatedNotesMap = Map<int, NoteTreeItem>.from(state.notesMap);
    updatedNotesMap[newNote.id] = newNote;

    // 更新子关系映射
    final updatedChildrenMap = Map<int, List<int>>.from(state.childrenMap);

    final updatedRootIds = List<int>.from(state.rootIds);

    if (parentId != null) {
      // 添加到父项的子列表
      final parentChildren = List<int>.from(state.childrenMap[parentId] ?? []);
      parentChildren.add(newNote.id);
      updatedChildrenMap[parentId] = parentChildren;

      // 如果父项不在映射中，确保添加空的子列表
      updatedChildrenMap[newNote.id] = [];

      // 确保父项被标记为文件夹
      if (updatedNotesMap.containsKey(parentId)) {
        final parent = updatedNotesMap[parentId]!;
        updatedNotesMap[parentId] = parent.copyWith(isFolder: true);
      }
    } else {
      // 添加到根ID
      updatedRootIds.add(newNote.id);

      // 初始化空的子列表
      updatedChildrenMap[newNote.id] = [];
    }

    state = state.copyWith(
      notesMap: updatedNotesMap,
      childrenMap: updatedChildrenMap,
      rootIds: updatedRootIds,
    );
  }

  void deleteNote(int noteId) {
    // TODO: 实现删除逻辑
  }

  void moveNote(int noteId, int newParentId) {
    // TODO: 实现移动逻辑
  }

  /// 更新特定节点的子节点
  void updateChildren(int parentId, List<NoteTreeItem> children) {
    final updatedChildrenMap = Map<int, List<int>>.from(state.childrenMap);
    updatedChildrenMap[parentId] = children.map((item) => item.id).toList();

    final updatedNotesMap = Map<int, NoteTreeItem>.from(state.notesMap);
    for (final child in children) {
      updatedNotesMap[child.id] = child;
    }

    // 确保父项存在并更新为文件夹
    if (updatedNotesMap.containsKey(parentId)) {
      final parent = updatedNotesMap[parentId]!;
      updatedNotesMap[parentId] = parent.copyWith(isFolder: true);
    }

    final newRootIds = List<int>.from(state.rootIds);
    if (!newRootIds.contains(parentId)) {
      newRootIds.add(parentId);
    }

    state = state.copyWith(
        notesMap: updatedNotesMap,
        childrenMap: updatedChildrenMap,
        rootIds: newRootIds);
  }

  /// 切换节点的展开/折叠状态
  void toggleExpand(NoteTreeItem item) {
    if (!item.isFolder) return;

    final currentExpandedIds = Set<int>.from(state.expandedFolderIds);
    final currentLoadingIds = Set<int>.from(state.loadingFolderIds);

    if (currentExpandedIds.contains(item.id)) {
      // 折叠
      currentExpandedIds.remove(item.id);
      state = state.copyWith(expandedFolderIds: currentExpandedIds);
    } else {
      // 展开
      currentExpandedIds.add(item.id);

      // 检查是否需要加载子节点
      final existingItem = state.notesMap[item.id];

      // 仅当它是一个文件夹且子节点尚未加载时才加载
      if (existingItem != null &&
          existingItem.isFolder &&
          existingItem.children.isEmpty) {
        currentLoadingIds.add(item.id); // 标记为正在加载
      }

      // 立即更新展开状态以提高响应性
      state = state.copyWith(
        expandedFolderIds: currentExpandedIds,
        loadingFolderIds: currentLoadingIds,
      );
    }
  }

  /// 获取笔记项
  NoteTreeItem? getNote(int id) {
    return state.notesMap[id];
  }

  /// 获取子笔记ID列表
  List<int> getChildren(int parentId) {
    return state.childrenMap[parentId] ?? [];
  }

  /// 检查笔记是否是文件夹（有子项或被标记为文件夹）
  bool isFolder(int id) {
    final note = state.notesMap[id];
    return note != null && (note.isFolder || getChildren(id).isNotEmpty);
  }

  /// 查询笔记是否为另一个笔记的后代
  bool isDescendantOf(int childId, int ancestorId) {
    final children = getChildren(ancestorId);
    if (children.isEmpty) {
      return false;
    }
    if (children.contains(childId)) {
      return true;
    }
    for (final child in children) {
      if (isDescendantOf(childId, child)) {
        return true;
      }
    }
    return false;
  }
}
