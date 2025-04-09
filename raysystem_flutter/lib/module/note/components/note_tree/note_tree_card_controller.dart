import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_manager.dart';
import 'package:raysystem_flutter/module/note/api/note/api_note_service.dart';
import 'package:raysystem_flutter/module/note/api/note/note_service.dart';
import 'package:raysystem_flutter/module/note/components/note/note_card.dart';
import 'package:raysystem_flutter/form/form_field.dart';
import 'package:raysystem_flutter/form/form_manager.dart';
import 'package:raysystem_flutter/module/note/api/note_tree/note_tree_service.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/note_tree_view.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';
import 'package:raysystem_flutter/module/note/providers/notes_provider.dart';
import 'package:openapi/openapi.dart';

/// Controller class for NoteTreeCard to separate logic from UI
class NoteTreeCardController {
  final NoteService noteService = ApiNoteService();
  final NoteTreeService treeService;
  final BuildContext context;
  final GlobalKey<NoteTreeViewClassicState> treeViewKey = GlobalKey();

  NoteTreeItem? selectedItem;
  bool isRefreshing = false;

  // Drag and drop properties
  NoteTreeItem? draggedItem;
  bool isDragging = false;

  NoteTreeCardController({
    required this.treeService,
    required this.context,
  });

  /// Handle selecting a note item
  void handleItemSelected(NoteTreeItem item) {
    selectedItem = item;
  }

  /// Handle double-clicking a note to open it in a new card
  void handleItemDoubleClicked(NoteTreeItem item, CardManager? cardManager) {
    // Use provided cardManager or try to get from context
    final manager = cardManager ?? _getCardManager();

    // Add new note card to the card flow
    manager.addCard(
      NoteCard(
        noteId: item.id,
      ),
    );
  }

  /// Get CardManager from context
  CardManager _getCardManager() {
    return Provider.of<CardManager>(context, listen: false);
  }

  /// Get NotesProvider from context
  NotesProvider _getNotesProvider() {
    return Provider.of<NotesProvider>(context, listen: false);
  }

  /// Start dragging a note item
  void handleStartDrag(NoteTreeItem item) {
    debugPrint('Starting drag for item: ${item.name} (ID: ${item.id})');
    draggedItem = item;
    isDragging = true;
  }

  /// End dragging without a drop
  void handleEndDrag() {
    draggedItem = null;
    isDragging = false;
  }

  /// Check if the target item can accept the dragged item
  /// Returns true if the drop is valid, false otherwise
  Future<bool> canAcceptDrop(NoteTreeItem targetItem) async {
    if (draggedItem == null) return false;

    // Cannot drop onto itself
    if (targetItem.id == draggedItem!.id) {
      debugPrint('Cannot drop onto itself');
      return false;
    }

    // Check if target is a descendant of the dragged item
    // This prevents creating cycles in the hierarchy
    bool isDescendant = await _isDescendantOf(targetItem.id, draggedItem!.id);
    if (isDescendant) {
      debugPrint('Cannot drop onto its own descendant');
      return false;
    }

    return true;
  }

  /// Check if itemId is a descendant of potentialAncestorId
  Future<bool> _isDescendantOf(int itemId, int potentialAncestorId) async {
    // Get the path from the root to the item
    final NotesApi? notesApi = treeService.getNotesApi();

    if (notesApi == null) {
      debugPrint('Error: NotesApi is null');
      return false;
    }

    try {
      final response = await notesApi.getNotePathNotesNoteIdPathGet(
        noteId: itemId,
      );

      if (response.data == null) return false;

      // Check if the potentialAncestor is in the path
      for (var note in response.data!) {
        if (note.id == potentialAncestorId) {
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('Error checking ancestry: $e');
      return false;
    }
  }

  /// Handle dropping a note item onto a target item
  Future<void> handleDrop(NoteTreeItem targetItem) async {
    debugPrint(
        '📦 handleDrop called for target: ${targetItem.name} (ID: ${targetItem.id})');

    // 复制当前的 draggedItem 到局部变量，避免在异步操作过程中它被清空
    final currentDraggedItem = draggedItem;
    if (currentDraggedItem == null) {
      debugPrint('❌ Error: draggedItem is null in handleDrop');
      return;
    }

    debugPrint(
        '📦 Dragged item: ${currentDraggedItem.name} (ID: ${currentDraggedItem.id})');

    // Final validation before proceeding
    final bool canDrop = await canAcceptDrop(targetItem);
    debugPrint('📦 canDrop validation result: $canDrop');

    if (!canDrop) {
      _showErrorSnackBar('Cannot move note to this location');
      return;
    }

    // Show loading dialog
    _showLoadingDialog('Moving note...');

    try {
      // Get the NotesApi instance
      final NotesApi? notesApi = treeService.getNotesApi();
      if (notesApi == null) {
        throw Exception('NotesApi instance is null');
      }

      debugPrint('📦 Calling moveNoteNotesNoteIdMovePost API...');
      debugPrint(
          '📦 Parameters: noteId=${currentDraggedItem.id}, newParentId=${targetItem.id}');

      final response = await notesApi.moveNoteNotesNoteIdMovePost(
        noteId: currentDraggedItem.id,
        newParentId: targetItem.id,
      );

      // Get parent IDs for refreshing
      final int? oldParentId =
          await treeViewKey.currentState?.findParentId(currentDraggedItem.id);
      debugPrint('📦 Old parent ID: $oldParentId');

      // Hide loading dialog
      if (context.mounted) Navigator.of(context).pop();

      debugPrint(
          '📦 API response received: ${response.data != null ? 'success' : 'null data'}');

      if (response.data != null) {
        // Reset cache to ensure fresh data
        treeService.resetCache();

        // Refresh the old parent if known
        if (oldParentId != null && treeViewKey.currentState != null) {
          if (oldParentId == 0) {
            // For root notes, refresh the entire tree
            debugPrint('📦 Refreshing entire tree');
            await treeViewKey.currentState!.loadInitialData();
          } else {
            // For non-root notes, refresh the old parent
            debugPrint('📦 Refreshing old parent: $oldParentId');
            await treeViewKey.currentState!.refreshChildren(oldParentId);
          }
        }

        // Ensure the target is marked as a folder and expanded
        if (!targetItem.isFolder) {
          targetItem.isFolder = true;
        }

        // Refresh the target to show the moved item
        debugPrint('📦 Refreshing target folder: ${targetItem.id}');
        await treeViewKey.currentState!.refreshChildren(targetItem.id);

        // Show success message
        _showSuccessSnackBar('Note moved successfully');
      } else {
        _showErrorSnackBar('Failed to move note');
      }
    } catch (e) {
      // Hide loading dialog if still showing
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      debugPrint('❌ Error in handleDrop: ${e.toString()}');
      _showErrorSnackBar('Error moving note: ${e.toString()}');
    } finally {
      // Reset drag state
      debugPrint('📦 Resetting drag state');
      draggedItem = null;
      isDragging = false;
    }
  }

  /// Handle adding a child note to a parent
  Future<void> handleAddChildNote(NoteTreeItem parentItem) async {
    // Show dialog to get note title
    final formResult = await _showAddNoteDialog();

    // Get the title from the form result
    final newNoteTitle = formResult?['title'] as String?;

    // If user cancelled, return
    if (newNoteTitle == null || newNoteTitle.isEmpty) return;

    // Show loading indicator
    _showLoadingDialog('Creating note...');

    try {
      // Create a new note with the parent ID
      final newNote = await noteService.createNote(
        title: newNoteTitle,
        contentAppflowy:
            jsonEncode(EditorState.blank().document.toJson()['document']),
        parentId: parentItem.id,
      );

      // Hide loading dialog
      if (context.mounted) Navigator.of(context).pop();

      if (newNote != null) {
        // Update parent to be a folder if it wasn't already
        if (!parentItem.isFolder) {
          parentItem.isFolder = true;
        }

        // Reset cache and refresh
        treeService.resetCache();

        // Refresh the children of the parent
        if (treeViewKey.currentState != null) {
          try {
            await treeViewKey.currentState!.refreshChildren(parentItem.id);
          } catch (e) {
            debugPrint('Error refreshing children after create: $e');
            await fullRefresh();
          }
        } else {
          await fullRefresh();
        }

        _showSuccessSnackBar('Note "$newNoteTitle" created successfully');
      } else {
        _showErrorSnackBar('Failed to create note');
      }
    } catch (e) {
      // Hide loading dialog if still showing
      if (context.mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _showErrorSnackBar('Error creating note: ${e.toString()}');
    }
  }

  /// Perform a full refresh of the tree
  Future<void> fullRefresh() async {
    isRefreshing = true;

    // Reset cache to ensure fresh data
    treeService.resetCache();

    // Add a small delay to allow UI updates
    await Future.delayed(const Duration(milliseconds: 300));

    // Refresh tree view with fresh data
    if (treeViewKey.currentState != null) {
      await treeViewKey.currentState!.loadInitialData();
    }

    isRefreshing = false;
  }

  /// Handle deleting a note
  Future<void> handleDeleteNote(NoteTreeItem item) async {
    // Get parent ID before deletion for refreshing later
    final int? parentId = await treeViewKey.currentState?.findParentId(item.id);

    // Confirm deletion
    final bool confirmDelete = await _showDeleteConfirmDialog(item.name);
    if (!confirmDelete) return;

    // Show loading indicator
    _showLoadingDialog('Deleting note...');

    // Get the notes provider
    final notesProvider = _getNotesProvider();

    try {
      // Call API to delete the note
      final success = await notesProvider.deleteNote(item.id);

      // Hide loading dialog
      Navigator.of(context).pop();

      if (success) {
        // Reset cache to ensure fresh data
        treeService.resetCache();

        // Refresh appropriate part of the tree
        if (parentId != null && treeViewKey.currentState != null) {
          if (parentId == 0) {
            // For root notes, refresh the entire tree
            isRefreshing = true;
            await treeViewKey.currentState!.loadInitialData();
            isRefreshing = false;
          } else {
            // For non-root notes, refresh the parent
            treeService.resetCache();
            await treeViewKey.currentState!.refreshChildren(parentId);
          }
        } else {
          // Fallback: refresh everything
          isRefreshing = true;
          if (treeViewKey.currentState != null) {
            await treeViewKey.currentState!.loadInitialData();
          }
          isRefreshing = false;
        }

        _showSuccessSnackBar('Note "${item.name}" deleted successfully');
      } else {
        _showErrorSnackBar('Failed to delete note');
      }
    } catch (e) {
      // Hide loading dialog if still showing
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _showErrorSnackBar('Error deleting note: ${e.toString()}');
    }
  }

  /// Show dialog to get the title for a new note
  Future<Map<String, dynamic>?> _showAddNoteDialog() async {
    return FormManager.showForm(
      context: context,
      title: 'Add Child Note',
      fields: [
        RSFormField(
          id: 'title',
          label: 'Note Title',
          type: FieldType.text,
          defaultValue: '',
        ),
      ],
    );
  }

  /// Show a confirmation dialog for deleting notes
  Future<bool> _showDeleteConfirmDialog(String noteName) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Note'),
              content: Text(
                  'Are you sure you want to delete "$noteName"? This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child:
                      const Text('DELETE', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  /// Show a loading dialog
  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  /// Show a success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Show an error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
