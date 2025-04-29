import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:raysystem_flutter/api/api_provider.dart';
import 'package:raysystem_flutter/module/note/api/note/note_service.dart';
import 'package:raysystem_flutter/module/note/api/note_tree/note_tree_service.dart';
import 'package:raysystem_flutter/module/note/components/note/provider/note_service_provider.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/provider/note_tree_service_provider.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final noteTreeProvider = AsyncNotifierProvider<NoteTree, NoteTreeState>(
  () => NoteTree(),
);

// State managed by the notifier
class NoteTreeState {
  final List<NoteTreeItem> items;
  final NoteTreeItem? selectedItem;
  final NoteTreeItem? draggedItem;
  final bool isDragging;
  final Set<int> expandedFolderIds; // Track expanded folders
  final Set<int> loadingFolderIds; // Track folders currently loading children
  final int? hoveredTargetId; // ID of the potential drop target being hovered
  final bool isHoverTargetValid; // Whether the hovered target is valid for drop

  const NoteTreeState({
    this.items = const [],
    this.selectedItem,
    this.draggedItem,
    this.isDragging = false,
    this.expandedFolderIds = const {},
    this.loadingFolderIds = const {}, // Initialize
    this.hoveredTargetId, // Initialize
    this.isHoverTargetValid = false, // Initialize
  });

  NoteTreeState copyWith({
    List<NoteTreeItem>? items,
    NoteTreeItem? selectedItem,
    NoteTreeItem? draggedItem,
    bool? isDragging,
    Set<int>? expandedFolderIds,
    Set<int>? loadingFolderIds, // Add
    int? hoveredTargetId, // Add
    bool? isHoverTargetValid, // Add
    bool clearSelectedItem = false, // Helper to clear selection
    bool clearDraggedItem = false, // Helper to clear drag state
    bool clearHoverState = false, // Helper to clear hover state
  }) {
    return NoteTreeState(
      items: items ?? this.items,
      selectedItem:
          clearSelectedItem ? null : selectedItem ?? this.selectedItem,
      draggedItem: clearDraggedItem ? null : draggedItem ?? this.draggedItem,
      isDragging: isDragging ?? this.isDragging,
      expandedFolderIds: expandedFolderIds ?? this.expandedFolderIds,
      loadingFolderIds: loadingFolderIds ?? this.loadingFolderIds, // Add
      hoveredTargetId: clearHoverState
          ? null
          : hoveredTargetId ?? this.hoveredTargetId, // Add & handle clear
      isHoverTargetValid: clearHoverState
          ? false
          : isHoverTargetValid ?? this.isHoverTargetValid, // Add & handle clear
    );
  }
}

class NoteTree extends AsyncNotifier<NoteTreeState> {
  NoteTreeService get _treeService => ref.read(noteTreeServiceProvider);
  NoteService get _noteService => ref.read(noteServiceProvider);
  NotesApi get _notesApi => ref.read(notesApiProvider);

  @override
  Future<NoteTreeState> build() async {
    // Load initial data
    final initialItems = await _treeService.getInitialItems();
    // TODO: Implement sorting logic if needed here or in the service
    return NoteTreeState(items: initialItems);
  }

  // --- Selection ---
  void selectItem(NoteTreeItem item) {
    state = AsyncData(state.value!.copyWith(selectedItem: item));
  }

  // --- Expansion ---
  Future<void> toggleExpand(NoteTreeItem item) async {
    if (!item.isFolder || state.value == null) return;

    final currentState = state.value!;
    final currentExpandedIds = Set<int>.from(currentState.expandedFolderIds);
    final currentLoadingIds = Set<int>.from(currentState.loadingFolderIds);
    bool needsLoading = false;

    if (currentState.expandedFolderIds.contains(item.id)) {
      // Collapse
      currentExpandedIds.remove(item.id);
      state = AsyncData(
          currentState.copyWith(expandedFolderIds: currentExpandedIds));
    } else {
      // Expand
      currentExpandedIds.add(item.id);
      // Check if children need loading (simple check, might need refinement)
      final existingItem = _findItemById(currentState.items, item.id);
      // Only load if it's a folder and children haven't been loaded yet
      if (existingItem != null &&
          existingItem.isFolder &&
          existingItem.children.isEmpty) {
        needsLoading = true;
        currentLoadingIds.add(item.id); // Mark as loading
      }
      // Immediately update expanded state for responsiveness
      state = AsyncData(currentState.copyWith(
        expandedFolderIds: currentExpandedIds,
        loadingFolderIds: currentLoadingIds, // Update loading state
      ));

      if (needsLoading) {
        await _loadChildrenAndUpdateState(item.id);
      }
    }
  }

  Future<void> _loadChildrenAndUpdateState(int parentId) async {
    if (state.value == null) return;
    final currentLoadingIds = Set<int>.from(state.value!.loadingFolderIds);
    try {
      final children = await _treeService.getChildrenFor(parentId);
      // TODO: Sort children if needed
      final updatedItems = _updateNodeChildren(
          List.from(state.value!.items), parentId, children);
      currentLoadingIds.remove(parentId); // Remove from loading
      if (updatedItems != null) {
        // Ensure the parent is still marked as expanded when updating children
        final currentExpandedIds =
            Set<int>.from(state.value!.expandedFolderIds);
        currentExpandedIds.add(parentId); // Keep it expanded

        state = AsyncData(state.value!.copyWith(
          items: updatedItems,
          loadingFolderIds: currentLoadingIds,
          expandedFolderIds: currentExpandedIds, // Pass updated expanded set
        ));
      } else {
        // If updateNodeChildren returned null (node not found?), just update loading state
        state = AsyncData(
            state.value!.copyWith(loadingFolderIds: currentLoadingIds));
      }
    } catch (e) {
      // Handle error, maybe revert expansion or show error state
      print("Error loading children for $parentId: $e");
      currentLoadingIds.remove(parentId); // Remove loading indicator on error
      // Optionally revert expansion
      final currentExpandedIds = Set<int>.from(state.value!.expandedFolderIds);
      currentExpandedIds.remove(parentId);
      state = AsyncData(state.value!.copyWith(
        loadingFolderIds: currentLoadingIds,
        expandedFolderIds: currentExpandedIds,
      ));
    }
  }

  // Helper to find an item recursively
  NoteTreeItem? _findItemById(List<NoteTreeItem> items, int id) {
    for (var item in items) {
      if (item.id == id) return item;
      if (item.children.isNotEmpty) {
        final foundInChildren = _findItemById(item.children, id);
        if (foundInChildren != null) return foundInChildren;
      }
    }
    return null;
  }

  // Helper to update children of a specific node
  List<NoteTreeItem>? _updateNodeChildren(List<NoteTreeItem> currentItems,
      int parentId, List<NoteTreeItem> newChildren) {
    List<NoteTreeItem> updatedList = [];
    bool updated = false;
    for (var item in currentItems) {
      if (item.id == parentId) {
        // Update children, keep existing expansion state from the item itself
        updatedList.add(item.copyWith(children: newChildren));
        updated = true;
      } else if (item.children.isNotEmpty) {
        final updatedChildren =
            _updateNodeChildren(item.children, parentId, newChildren);
        if (updatedChildren != null) {
          updatedList.add(item.copyWith(children: updatedChildren));
          updated = true; // Mark as updated if a child was updated
        } else {
          updatedList.add(item);
        }
      } else {
        updatedList.add(item);
      }
    }
    return updated
        ? updatedList
        : null; // Return null if no update occurred at this level
  }

  // --- Drag and Drop ---
  void startDrag(NoteTreeItem item) {
    if (state.value == null) return;
    state =
        AsyncData(state.value!.copyWith(draggedItem: item, isDragging: true));
  }

  void endDrag() {
    if (state.value == null) return;
    // Clear drag item and hover state when drag ends
    state = AsyncData(state.value!.copyWith(
        clearDraggedItem: true, isDragging: false, clearHoverState: true));
  }

  // Called by View when hovering over a potential target
  Future<void> hoverTarget(NoteTreeItem targetItem) async {
    final dragged = state.value?.draggedItem;
    if (dragged == null || state.value == null) return;

    bool isValid = true;
    // 1. Cannot drop on self
    if (targetItem.id == dragged.id) {
      isValid = false;
    } else {
      // 2. Cannot drop on a descendant
      bool isDescendant = await _isDescendantOf(targetItem.id, dragged.id);
      if (isDescendant) {
        isValid = false;
      }
      // 3. Can only drop on folders (optional rule, implement if needed)
      // if (!targetItem.isFolder) {
      //   isValid = false;
      // }
    }

    // Update state with hover target ID and validity
    state = AsyncData(state.value!.copyWith(
      hoveredTargetId: targetItem.id,
      isHoverTargetValid: isValid,
    ));
  }

  // Called by View when leaving a potential target
  void leaveTarget() {
    if (state.value == null) return;
    // Clear hover state
    state = AsyncData(state.value!.copyWith(clearHoverState: true));
  }

  Future<bool> _isDescendantOf(int itemId, int potentialAncestorId) async {
    // Optimization: If potentialAncestorId is not a folder, it cannot be an ancestor
    // This requires fetching the ancestor item if not already available, might be complex.
    // Keeping the API call for now.
    try {
      final response =
          await _notesApi.getNotePathNotesNoteIdPathGet(noteId: itemId);
      // Check if any note in the path (excluding the item itself) matches the potential ancestor
      return response.data?.any(
              (note) => note.id == potentialAncestorId && note.id != itemId) ??
          false;
    } catch (e) {
      debugPrint('Error checking ancestry: $e');
      return true; // Assume descendant on error to prevent invalid drops
    }
  }

  // Returns true on success, false on failure. UI can show feedback based on result.
  Future<bool> moveNote(NoteTreeItem targetItem) async {
    final dragged = state.value?.draggedItem;
    if (dragged == null ||
        state.value == null ||
        state.value?.hoveredTargetId != targetItem.id ||
        !state.value!.isHoverTargetValid) {
      endDrag();
      return false;
    }

    Set<int>? ensureTargetExpanded;
    // Ensure the target folder is marked for expansion if it's a folder
    if (targetItem.isFolder) {
      ensureTargetExpanded = {targetItem.id};
    }

    try {
      await _notesApi.moveNoteNotesNoteIdMovePost(
        noteId: dragged.id,
        newParentId: targetItem.id,
      );
      _treeService.resetCache(); // Reset service cache

      // Refresh the tree, preserving expansion and ensuring target is expanded
      await refreshTree(
          preserveExpansion: true, ensureExpanded: ensureTargetExpanded);

      // endDrag() is called implicitly by refreshTree setting a new state
      return true;
    } catch (e) {
      debugPrint('Error moving note: $e');
      // Refresh preserving expansion even on error to maintain consistency
      await refreshTree(
          preserveExpansion: true, ensureExpanded: ensureTargetExpanded);
      // endDrag() is called implicitly
      return false;
    }
  }

  // --- CRUD Operations ---

  // Returns the created Note ID or null on failure
  Future<int?> addChildNote(NoteTreeItem parentItem, String title) async {
    if (state.value == null) return null;

    try {
      final newNote = await _noteService.createNote(
        title: title,
        contentAppflowy:
            jsonEncode(EditorState.blank().document.toJson()['document']),
        parentId: parentItem.id,
      );
      if (newNote != null) {
        _treeService.resetCache();

        // Refresh the tree, preserving expansion and ensuring the parent is expanded
        await refreshTree(
            preserveExpansion: true, ensureExpanded: {parentItem.id});

        // After refresh, ensure the new node is visible (parent expanded)
        // The recursive loading in refreshTree should handle this.

        return newNote.id;
      }
      return null;
    } catch (e) {
      debugPrint('Error creating note: $e');
      // Optionally refresh even on error, preserving expansion
      await refreshTree(
          preserveExpansion: true, ensureExpanded: {parentItem.id});
      return null;
    }
  }

  // Returns true on success, false on failure
  Future<bool> deleteNote(NoteTreeItem item) async {
    if (state.value == null) return false;

    // Preserve expansion state before deletion
    // final currentExpandedIds = Set<int>.from(state.value!.expandedFolderIds);

    try {
      // Assuming NotesProvider handles the actual deletion API call
      // final success = await ref.read(notesProvider.notifier).deleteNote(item.id);
      final response =
          await _notesApi.deleteNoteNotesNoteIdDelete(noteId: item.id);
      // ignore: unnecessary_null_comparison
      final success = response != null; // Basic check if response is not null

      if (success) {
        _treeService.resetCache();

        // Refresh preserving expansion state
        await refreshTree(preserveExpansion: true);

        // Clear selection if the deleted item was selected
        // Need to read the state *after* the refresh completes
        // Use ref.read to get the latest state value after async gap
        final refreshedStateValue = ref.read(noteTreeProvider).value;
        if (refreshedStateValue?.selectedItem?.id == item.id) {
          // It's safer to update the state via the notifier itself if possible,
          // but directly assigning to state is the pattern used here.
          state =
              AsyncData(refreshedStateValue!.copyWith(clearSelectedItem: true));
        }

        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting note: $e');
      await refreshTree(
          preserveExpansion: true); // Refresh preserving expansion on error
      return false;
    }
  }

  // --- Refreshing ---
  Future<void> refreshTree(
      {bool preserveExpansion = false, Set<int>? ensureExpanded}) async {
    // Capture current state details *before* any async operations
    final previousStateValue =
        state.value; // Keep the whole previous state if needed
    final currentExpandedIds = preserveExpansion && previousStateValue != null
        ? Set<int>.from(previousStateValue.expandedFolderIds)
        : <int>{};
    if (ensureExpanded != null) {
      currentExpandedIds.addAll(ensureExpanded);
    }
    final currentSelectedId = previousStateValue?.selectedItem?.id;

    // Reset cache before fetching new data
    _treeService.resetCache();

    try {
      // Fetch the root items first
      final initialItems = await _treeService.getInitialItems();

      // Prepare the initial structure of the new state
      NoteTreeState newState = NoteTreeState(
        items: initialItems,
        expandedFolderIds: currentExpandedIds, // Use the combined set
        selectedItem: null, // Selection will be restored later
        loadingFolderIds: {}, // Start with no folders loading
      );

      // If expansion needs preserving/ensuring, load necessary children recursively
      if (currentExpandedIds.isNotEmpty) {
        // This function now handles loading and returns the state with children populated
        newState = await _recursivelyLoadChildrenForState(
            newState, currentExpandedIds);
      }

      // Restore selection *after* all loading and item updates are done
      if (currentSelectedId != null) {
        final finalSelectedItem =
            _findItemById(newState.items, currentSelectedId);
        // Use copyWith on the potentially updated newState from recursive loading
        newState = newState.copyWith(
          selectedItem: finalSelectedItem,
          // Clear selection if item not found
          clearSelectedItem: finalSelectedItem == null,
        );
      } else {
        newState = newState.copyWith(clearSelectedItem: true);
      }

      // Single final state update
      state = AsyncData(newState);
    } catch (e, s) {
      debugPrint("Error during refreshTree: $e \n$s");
      // Set error state. Consider restoring previous state if desired.
      state = AsyncError(e, s);
      // Example: Restore previous state on error
      // if (previousStateValue != null) {
      //   state = AsyncData(previousStateValue);
      // }
    }
  }

  // Helper to load children for all expanded folders within a given state's items
  Future<NoteTreeState> _recursivelyLoadChildrenForState(
      NoteTreeState currentState, Set<int> expandedIdsToLoad) async {
    List<NoteTreeItem> currentItems = List.from(currentState.items);
    Set<int> currentLoadingIds = Set.from(currentState.loadingFolderIds);
    bool itemsChangedOverall = false;

    // Find all folders that are expanded and need loading in the current tree structure
    List<int> foldersToLoadNow = [];
    _findFoldersToLoadRecursive(
        currentItems, expandedIdsToLoad, foldersToLoadNow);

    if (foldersToLoadNow.isEmpty) {
      // Return current state if no loading needed at this level
      // Ensure loading IDs are cleared if they somehow persisted
      return currentState.copyWith(
          loadingFolderIds: currentLoadingIds..removeAll(foldersToLoadNow));
    }

    // --- Indicate Loading Start --- (Update loading IDs in the state to be processed)
    currentLoadingIds.addAll(foldersToLoadNow);
    // We work on a copy of the state, not modifying the global state here
    NoteTreeState stateBeforeLoading =
        currentState.copyWith(loadingFolderIds: currentLoadingIds);

    // --- Load Data --- (Concurrently)
    Map<int, List<NoteTreeItem>> loadedChildrenMap = {};
    List<Future> loadingFutures = [];
    Set<int> successfullyLoadedIds = {};
    Set<int> failedLoadIds = {};

    for (int folderId in foldersToLoadNow) {
      loadingFutures.add(() async {
        try {
          final children = await _treeService.getChildrenFor(folderId);
          loadedChildrenMap[folderId] = children;
          successfullyLoadedIds.add(folderId);
        } catch (e) {
          debugPrint(
              "Error loading children for $folderId during recursive load: $e");
          failedLoadIds.add(folderId);
          // Decide how to handle failed loads - keep loading indicator or remove?
          // Removing for now, UI won't show loading for failed nodes.
        }
      }());
    }
    await Future.wait(loadingFutures);

    // --- Process Loaded Data --- (Update items based on successful loads)
    List<NoteTreeItem> itemsAfterLoading = List.from(stateBeforeLoading.items);
    if (loadedChildrenMap.isNotEmpty) {
      itemsChangedOverall = true;
      itemsAfterLoading =
          _updateMultipleNodesChildren(itemsAfterLoading, loadedChildrenMap);
    }

    // --- Update Loading State --- (Remove all attempted IDs from loading set)
    currentLoadingIds.removeAll(foldersToLoadNow);

    // --- Prepare State for Recursion/Return ---
    NoteTreeState stateAfterLoading = stateBeforeLoading.copyWith(
      items: itemsChangedOverall ? itemsAfterLoading : stateBeforeLoading.items,
      loadingFolderIds: currentLoadingIds, // Reflects completion of this batch
    );

    // --- Recurse if needed --- (Check within the *newly loaded* children)
    Set<int> remainingExpandedIds = Set.from(expandedIdsToLoad);
    remainingExpandedIds
        .removeAll(foldersToLoadNow); // Don't re-check folders just loaded

    bool deeperLoadNeeded = false;
    if (remainingExpandedIds.isNotEmpty && itemsChangedOverall) {
      List<int> deeperFoldersToLoad = [];
      // Search within the *updated* items list (itemsAfterLoading)
      _findFoldersToLoadRecursive(
          itemsAfterLoading, remainingExpandedIds, deeperFoldersToLoad);
      if (deeperFoldersToLoad.isNotEmpty) {
        deeperLoadNeeded = true;
      }
    }

    if (deeperLoadNeeded) {
      // Pass the updated state and remaining IDs for the next level
      return await _recursivelyLoadChildrenForState(
          stateAfterLoading, remainingExpandedIds);
    } else {
      // Base case: return the state updated after all necessary loading is done
      return stateAfterLoading;
    }
  }

  // Helper to find folders that are in expandedIds and need children loaded
  void _findFoldersToLoadRecursive(
      List<NoteTreeItem> items, Set<int> expandedIds, List<int> foldersToLoad) {
    for (var item in items) {
      // If this item ID is marked for expansion...
      if (expandedIds.contains(item.id)) {
        // ...and its children are currently empty in the state...
        if (item.children.isEmpty) {
          // ...then mark it for loading.
          // We assume if it's marked for expansion, it *should* be treated as a folder,
          // even if its local isFolder flag isn't updated yet.
          foldersToLoad.add(item.id);
        } else {
          // If children are already present, recurse into them to find deeper expanded folders
          _findFoldersToLoadRecursive(
              item.children, expandedIds, foldersToLoad);
        }
      }
      // If the item is not marked for expansion, but it *is* a folder and has children,
      // still recurse into its children in case a deeper node *is* marked for expansion.
      // This handles cases where an intermediate parent isn't expanded, but a child is.
      else if (item.isFolder && item.children.isNotEmpty) {
        _findFoldersToLoadRecursive(item.children, expandedIds, foldersToLoad);
      }
    }
  }

  // Helper to update children for multiple nodes efficiently (recursive)
  List<NoteTreeItem> _updateMultipleNodesChildren(
      List<NoteTreeItem> currentItems,
      Map<int, List<NoteTreeItem>> childrenMap) {
    List<NoteTreeItem> updatedList = [];
    bool changed = false;
    for (var item in currentItems) {
      NoteTreeItem updatedItem = item; // Start with the original item
      if (childrenMap.containsKey(item.id)) {
        // Update this item's children
        final newChildren =
            childrenMap[item.id]!; // Should not be null if key exists
        updatedItem = item.copyWith(
          children: newChildren,
          // Explicitly mark as folder if children were loaded for it.
          // This handles the transition from leaf node to parent node.
          isFolder: true,
        );
        changed = true; // Mark change at this level
      } else if (item.children.isNotEmpty) {
        // Recurse into existing children (if any)
        final updatedChildren =
            _updateMultipleNodesChildren(item.children, childrenMap);
        // Only copyWith if children actually changed during recursion
        if (!identical(updatedChildren, item.children)) {
          updatedItem = item.copyWith(children: updatedChildren);
          changed = true; // Mark change at this level
        }
      }
      // If neither the item itself nor its descendants were updated,
      // updatedItem remains identical to item.
      updatedList.add(updatedItem);
    }
    // Return a new list only if changes occurred, otherwise return original.
    return changed ? updatedList : currentItems;
  }
}
