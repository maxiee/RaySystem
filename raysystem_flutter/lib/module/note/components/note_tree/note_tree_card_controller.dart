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

/// Controller class for NoteTreeCard to separate logic from UI
class NoteTreeCardController {
  final NoteService noteService = ApiNoteService();
  final NoteTreeService treeService;
  final BuildContext context;
  final GlobalKey<NoteTreeViewClassicState> treeViewKey = GlobalKey();

  NoteTreeItem? selectedItem;
  bool isRefreshing = false;

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
      SizedBox(
        height: 400,
        child: NoteCard(
          noteId: item.id,
          isEditable: true,
        ),
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
