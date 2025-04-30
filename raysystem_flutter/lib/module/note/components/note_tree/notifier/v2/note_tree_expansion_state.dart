import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/v2/note_tree_data_state.dart';

/// 管理笔记树展开状态的状态类
class NoteTreeExpansionState {
  /// 已展开的笔记ID集合
  final Set<int> expandedIds;

  /// 当前正在加载子项的笔记ID集合
  final Set<int> loadingIds;

  const NoteTreeExpansionState({
    this.expandedIds = const {},
    this.loadingIds = const {},
  });

  /// 创建状态副本
  NoteTreeExpansionState copyWith({
    Set<int>? expandedIds,
    Set<int>? loadingIds,
  }) {
    return NoteTreeExpansionState(
      expandedIds: expandedIds ?? this.expandedIds,
      loadingIds: loadingIds ?? this.loadingIds,
    );
  }

  /// 检查笔记是否已展开
  bool isExpanded(int id) => expandedIds.contains(id);

  /// 检查笔记是否正在加载
  bool isLoading(int id) => loadingIds.contains(id);
}

/// 管理笔记树展开状态的Provider
final noteTreeExpansionProvider =
    NotifierProvider<NoteTreeExpansionNotifier, NoteTreeExpansionState>(
  () => NoteTreeExpansionNotifier(),
);

class NoteTreeExpansionNotifier extends Notifier<NoteTreeExpansionState> {
  @override
  NoteTreeExpansionState build() {
    return const NoteTreeExpansionState();
  }

  /// 切换笔记的展开状态
  Future<void> toggleExpand(int noteId) async {
    final dataProvider = ref.read(noteTreeDataProvider);
    if (dataProvider.value == null) return;

    // 如果笔记不是文件夹，不执行任何操作
    if (!dataProvider.value!.isFolder(noteId)) return;

    final currentExpanded = Set<int>.from(state.expandedIds);
    final currentLoading = Set<int>.from(state.loadingIds);
    bool needsLoading = false;

    if (currentExpanded.contains(noteId)) {
      // 折叠操作
      currentExpanded.remove(noteId);
      state = state.copyWith(expandedIds: currentExpanded);
    } else {
      // 展开操作
      currentExpanded.add(noteId);

      // 检查是否需要加载子项
      final childrenIds = dataProvider.value!.getChildrenIds(noteId);
      if (childrenIds.isEmpty) {
        // 子项为空，可能需要加载
        needsLoading = true;
        currentLoading.add(noteId);
      }

      // 首先更新状态，使UI响应迅速
      state = state.copyWith(
          expandedIds: currentExpanded, loadingIds: currentLoading);

      // 如果需要，加载子项
      if (needsLoading) {
        try {
          await ref.read(noteTreeDataProvider.notifier).loadChildren(noteId);
        } catch (e) {
          debugPrint("Error loading children during expand: $e");
          // 出错时可能要恢复展开状态
          currentExpanded.remove(noteId);
        } finally {
          // 无论成功或失败，都移除加载状态
          currentLoading.remove(noteId);
          state = state.copyWith(
              expandedIds: currentExpanded, loadingIds: currentLoading);
        }
      }
    }
  }

  /// 标记笔记为展开状态
  void expandNote(int noteId) {
    if (!state.expandedIds.contains(noteId)) {
      final updated = Set<int>.from(state.expandedIds)..add(noteId);
      state = state.copyWith(expandedIds: updated);
    }
  }

  /// 确保指定的多个笔记处于展开状态
  Future<void> ensureExpanded(Set<int> noteIds) async {
    if (noteIds.isEmpty) return;

    // 过滤出需要加载子项的笔记ID
    final dataState = ref.read(noteTreeDataProvider).value;
    if (dataState == null) return;

    // 记录当前要加载的ID
    final toLoad = <int>[];
    for (final id in noteIds) {
      // 如果已经在展开集合中，但子项为空，需要加载
      if (dataState.isFolder(id) &&
          dataState.getChildrenIds(id).isEmpty &&
          !state.loadingIds.contains(id)) {
        toLoad.add(id);
      }
    }

    // 更新展开状态
    final updatedExpandedIds = Set<int>.from(state.expandedIds)
      ..addAll(noteIds);

    if (toLoad.isEmpty) {
      // 如果没有需要加载的，直接更新状态
      state = state.copyWith(expandedIds: updatedExpandedIds);
      return;
    }

    // 添加加载状态
    final updatedLoadingIds = Set<int>.from(state.loadingIds)..addAll(toLoad);
    state = state.copyWith(
        expandedIds: updatedExpandedIds, loadingIds: updatedLoadingIds);

    // 并发加载所有需要的子项
    final loadingFutures = <Future>[];
    for (final id in toLoad) {
      loadingFutures.add(ref
          .read(noteTreeDataProvider.notifier)
          .loadChildren(id)
          .catchError((e) {
        debugPrint("Error loading children for $id: $e");
        return <dynamic>[];
      }));
    }

    // 等待所有加载完成
    await Future.wait(loadingFutures);

    // 移除加载状态
    final finalLoadingIds = Set<int>.from(state.loadingIds)..removeAll(toLoad);
    state = state.copyWith(loadingIds: finalLoadingIds);
  }

  /// 清除加载状态
  void clearLoading(int noteId) {
    if (state.loadingIds.contains(noteId)) {
      final updated = Set<int>.from(state.loadingIds)..remove(noteId);
      state = state.copyWith(loadingIds: updated);
    }
  }

  /// 保存当前展开状态
  Set<int> saveExpandedState() {
    return Set<int>.from(state.expandedIds);
  }

  /// 恢复之前保存的展开状态
  Future<void> restoreExpandedState(Set<int> savedState) async {
    state = state.copyWith(expandedIds: savedState);
    await ensureExpanded(savedState);
  }

  /// 重置展开状态，保留指定的ID
  void resetExpandedState({Set<int> preserve = const {}}) {
    if (preserve.isEmpty) {
      // 完全重置
      state = const NoteTreeExpansionState();
    } else {
      // 仅保留指定的ID
      state = state.copyWith(
        expandedIds: preserve,
        loadingIds: const {},
      );
    }
  }
}
