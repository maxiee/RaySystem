import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/api/note_tree/note_tree_service.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_base_notifier.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_state.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/provider/note_tree_service_provider.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';

/// 管理树节点展开状态的提供者
final noteTreeExpansionProvider =
    NotifierProvider<NoteTreeExpansionNotifier, NoteTreeExpansionState>(
  () => NoteTreeExpansionNotifier(),
);

class NoteTreeExpansionNotifier extends Notifier<NoteTreeExpansionState> {
  NoteTreeService get _treeService => ref.read(noteTreeServiceProvider);

  @override
  NoteTreeExpansionState build() {
    return const NoteTreeExpansionState();
  }

  /// 切换节点的展开/折叠状态
  Future<void> toggleExpand(NoteTreeItem item) async {
    if (!item.isFolder) return;

    final currentExpandedIds = Set<int>.from(state.expandedFolderIds);
    final currentLoadingIds = Set<int>.from(state.loadingFolderIds);
    bool needsLoading = false;

    if (currentExpandedIds.contains(item.id)) {
      // 折叠
      currentExpandedIds.remove(item.id);
      state = state.copyWith(expandedFolderIds: currentExpandedIds);
    } else {
      // 展开
      currentExpandedIds.add(item.id);

      // 检查是否需要加载子节点
      final baseNotifier = ref.read(noteTreeBaseProvider.notifier);
      final existingItem = baseNotifier.findItemById(item.id);

      // 仅当它是一个文件夹且子节点尚未加载时才加载
      if (existingItem != null &&
          existingItem.isFolder &&
          existingItem.children.isEmpty) {
        needsLoading = true;
        currentLoadingIds.add(item.id); // 标记为正在加载
      }

      // 立即更新展开状态以提高响应性
      state = state.copyWith(
        expandedFolderIds: currentExpandedIds,
        loadingFolderIds: currentLoadingIds,
      );

      if (needsLoading) {
        await _loadChildrenAndUpdateState(item.id);
      }
    }
  }

  /// 加载子节点并更新状态
  Future<void> _loadChildrenAndUpdateState(int parentId) async {
    final currentLoadingIds = Set<int>.from(state.loadingFolderIds);

    try {
      final children = await _treeService.getChildrenFor(parentId);

      // 更新基础树结构中的节点
      final baseNotifier = ref.read(noteTreeBaseProvider.notifier);
      await baseNotifier.updateNodeChildren(parentId, children);

      // 更新加载状态
      currentLoadingIds.remove(parentId);

      // 确保父节点在更新子节点时仍然标记为展开
      final currentExpandedIds = Set<int>.from(state.expandedFolderIds);
      currentExpandedIds.add(parentId); // 保持展开状态

      state = state.copyWith(
        loadingFolderIds: currentLoadingIds,
        expandedFolderIds: currentExpandedIds,
      );
    } catch (e) {
      // 处理错误，可能恢复展开状态或显示错误状态
      debugPrint("Error loading children for $parentId: $e");

      // 移除加载指示器
      currentLoadingIds.remove(parentId);

      // 可选地恢复展开状态
      final currentExpandedIds = Set<int>.from(state.expandedFolderIds);
      currentExpandedIds.remove(parentId);

      state = state.copyWith(
        loadingFolderIds: currentLoadingIds,
        expandedFolderIds: currentExpandedIds,
      );
    }
  }

  /// 查找需要加载子节点的文件夹
  void findFoldersToLoadRecursive(
      List<NoteTreeItem> items, Set<int> expandedIds, List<int> foldersToLoad) {
    for (var item in items) {
      // 如果该项ID标记为展开...
      if (expandedIds.contains(item.id)) {
        // ...且其子节点当前为空...
        if (item.children.isEmpty) {
          // ...则将其标记为需要加载
          // 我们假设如果它被标记为展开，则*应该*被视为文件夹
          // 即使其本地isFolder标志尚未更新
          foldersToLoad.add(item.id);
        } else {
          // 如果子节点已经存在，递归进入它们以查找更深层次的展开文件夹
          findFoldersToLoadRecursive(item.children, expandedIds, foldersToLoad);
        }
      }
      // 如果该项未标记为展开，但*是*一个文件夹且有子节点，
      // 仍然递归进入其子节点，以防更深层的节点被标记为展开。
      // 这处理中间父节点未展开但子节点展开的情况。
      else if (item.isFolder && item.children.isNotEmpty) {
        findFoldersToLoadRecursive(item.children, expandedIds, foldersToLoad);
      }
    }
  }

  /// 递归加载所有展开的文件夹
  Future<void> loadExpandedFolders(Set<int> expandedIdsToLoad) async {
    // 获取当前树结构
    final baseState = ref.read(noteTreeBaseProvider).value;
    if (baseState == null) return;

    List<NoteTreeItem> currentItems = List.from(baseState.items);
    Set<int> currentLoadingIds = Set.from(state.loadingFolderIds);

    // 查找当前树结构中所有展开且需要加载的文件夹
    List<int> foldersToLoadNow = [];
    findFoldersToLoadRecursive(
        currentItems, expandedIdsToLoad, foldersToLoadNow);

    if (foldersToLoadNow.isEmpty) {
      // 如果这一级不需要加载，则确保加载ID已清除
      state = state.copyWith(
          loadingFolderIds: currentLoadingIds..removeAll(foldersToLoadNow));
      return;
    }

    // --- 指示加载开始 --- (更新要处理的状态中的加载ID)
    currentLoadingIds.addAll(foldersToLoadNow);
    state = state.copyWith(loadingFolderIds: currentLoadingIds);

    // --- 加载数据 --- (并发)
    Map<int, List<NoteTreeItem>> loadedChildrenMap = {};
    List<Future> loadingFutures = [];

    for (int folderId in foldersToLoadNow) {
      loadingFutures.add(() async {
        try {
          final children = await _treeService.getChildrenFor(folderId);
          loadedChildrenMap[folderId] = children;
        } catch (e) {
          debugPrint(
              "Error loading children for $folderId during recursive load: $e");
          // 决定如何处理加载失败 - 保持加载指示器还是移除？
          // 暂时移除，UI不会显示失败节点的加载状态
        }
      }());
    }
    await Future.wait(loadingFutures);

    // --- 处理加载的数据 --- (根据成功加载更新项目)
    if (loadedChildrenMap.isNotEmpty) {
      // 更新基础树结构
      final baseNotifier = ref.read(noteTreeBaseProvider.notifier);
      await baseNotifier.updateMultipleNodesChildren(loadedChildrenMap);
    }

    // --- 更新加载状态 --- (从加载集中移除所有尝试的ID)
    currentLoadingIds.removeAll(foldersToLoadNow);
    state = state.copyWith(loadingFolderIds: currentLoadingIds);

    // --- 如果需要，递归 --- (检查*新加载的*子节点中)
    Set<int> remainingExpandedIds = Set.from(expandedIdsToLoad);
    remainingExpandedIds.removeAll(foldersToLoadNow); // 不重新检查刚加载的文件夹

    if (remainingExpandedIds.isNotEmpty) {
      // 获取更新后的树结构
      final updatedBaseState = ref.read(noteTreeBaseProvider).value;
      if (updatedBaseState != null) {
        List<int> deeperFoldersToLoad = [];
        // 在*更新后的*项目列表中搜索
        findFoldersToLoadRecursive(
            updatedBaseState.items, remainingExpandedIds, deeperFoldersToLoad);
        if (deeperFoldersToLoad.isNotEmpty) {
          // 为下一级传递更新后的状态和剩余ID
          await loadExpandedFolders(remainingExpandedIds);
        }
      }
    }
  }
}
