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
    // Use the validated state from hoverTarget
    if (dragged == null ||
        state.value == null ||
        state.value?.hoveredTargetId != targetItem.id ||
        !state.value!.isHoverTargetValid) {
      endDrag(); // Ensure drag state is reset if drop is invalid/aborted
      return false;
    }

    // Optimistic UI update (optional but improves perceived performance)
    // You could temporarily move the node in the state here

    try {
      await _notesApi.moveNoteNotesNoteIdMovePost(
        noteId: dragged.id,
        newParentId: targetItem.id,
      );
      _treeService.resetCache(); // Reset service cache
      await refreshTree(); // Reload the entire tree for simplicity after move
      // endDrag() is called implicitly by refreshTree setting a new state,
      // but call explicitly for clarity if refreshTree fails or is modified.
      // endDrag(); // Reset drag state on success
      return true;
    } catch (e) {
      debugPrint('Error moving note: $e');
      // Revert optimistic update if you implemented one
      await refreshTree(); // Refresh to get consistent state after error
      // endDrag() is called implicitly by refreshTree setting a new state
      // endDrag(); // Reset drag state on failure
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
        // Refresh parent or whole tree
        await refreshNodeAndEnsureVisible(parentItem.id);
        return newNote.id;
      }
      return null;
    } catch (e) {
      debugPrint('Error creating note: $e');
      return null;
    }
  }

  // Returns true on success, false on failure
  Future<bool> deleteNote(NoteTreeItem item) async {
    if (state.value == null) return false;

    // Find parent ID *before* deletion for refresh logic
    final parentId = _findParentId(state.value!.items, item.id);

    try {
      // Assuming NotesProvider handles the actual deletion API call
      // final success = await ref.read(notesProvider.notifier).deleteNote(item.id);
      final response =
          await _notesApi.deleteNoteNotesNoteIdDelete(noteId: item.id);
      // ignore: unnecessary_null_comparison
      final success = response != null; // Basic check if response is not null

      if (success) {
        _treeService.resetCache();
        if (parentId != null) {
          await refreshNodeAndEnsureVisible(parentId);
        } else {
          await refreshTree(); // It was a root item
        }
        // Clear selection if the deleted item was selected
        if (state.value?.selectedItem?.id == item.id) {
          // Get current state again as it might have changed during refresh
          final currentState = state.value;
          if (currentState != null) {
            state = AsyncData(currentState.copyWith(clearSelectedItem: true));
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting note: $e');
      await refreshTree(); // Refresh on error to ensure consistency
      return false;
    }
  }

  // --- Refreshing ---
  Future<void> refreshTree() async {
    state = const AsyncLoading(); // Set loading state
    _treeService.resetCache();
    // Re-fetch and build the state
    try {
      final newState = await build();
      state = AsyncData(newState);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  // Refreshes a specific node and its ancestors if needed to ensure it's visible
  Future<void> refreshNodeAndEnsureVisible(int nodeId) async {
    if (state.value == null) return;

    // Option 1: Simple refresh (used currently)
    await refreshTree();

    // Option 2: More complex targeted refresh (Example structure)
    /*
    try {
      // 1. Ensure node and ancestors are expanded
      final path = await _getPathToNode(nodeId); // Need a method to get path
      final currentExpanded = Set<int>.from(state.value!.expandedFolderIds);
      bool expansionChanged = false;
      for (var ancestorId in path) {
        if (!currentExpanded.contains(ancestorId)) {
          currentExpanded.add(ancestorId);
          expansionChanged = true;
        }
      }
      if (expansionChanged) {
         state = AsyncData(state.value!.copyWith(expandedFolderIds: currentExpanded));
      }

      // 2. Reload children for the node itself
      await _loadChildrenAndUpdateState(nodeId);

      // 3. Potentially reload children for the parent if the structure changed significantly
      //    (e.g., if the deleted/added node was the only child)

    } catch (e) {
      print("Error during targeted refresh for $nodeId: $e");
      await refreshTree(); // Fallback to full refresh on error
    }
    */
  }

  // --- Helpers ---
  int? _findParentId(List<NoteTreeItem> items, int childId,
      {int? currentParentId}) {
    for (var item in items) {
      if (item.id == childId) {
        return currentParentId; // Found it, return its parent
      }
      if (item.children.isNotEmpty) {
        final foundParentId =
            _findParentId(item.children, childId, currentParentId: item.id);
        if (foundParentId != null) {
          return foundParentId; // Found in subtree
        }
      }
    }
    return null; // Not found in this branch
  }
}
