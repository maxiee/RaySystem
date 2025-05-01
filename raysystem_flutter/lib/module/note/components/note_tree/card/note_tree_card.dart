import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/card/card_manager.dart';
import 'package:raysystem_flutter/form/form_field.dart';
import 'package:raysystem_flutter/form/form_manager.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/note_tree_view.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/new/base/note_tree_provider.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/note_tree.dart';

/// A card widget that displays a note tree explorer
class NoteTreeCard extends ConsumerWidget {
  /// 卡片管理器，用于添加新卡片
  final CardManager? cardManager;

  const NoteTreeCard({
    super.key,
    this.cardManager,
  });

  // --- Dialog/Snackbar Helpers (moved here from controller) ---
  /// Show a loading dialog
  void _showLoadingDialog(BuildContext context, String message) {
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

  void _hideLoadingDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  /// Show a success snackbar
  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Show an error snackbar
  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Show dialog to get the title for a new note
  Future<Map<String, dynamic>?> _showAddNoteDialog(BuildContext context) async {
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
  Future<bool> _showDeleteConfirmDialog(
      BuildContext context, String noteName) async {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(noteTreeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Stack(
            children: [
              NoteTreeViewClassic(
                // Pass data and callbacks
                selectedItemId: treeState.selectedItem?.id,
                expandedFolderIds: treeState.expandedFolderIds,
                loadingFolderIds: treeState.loadingFolderIds, // Added
                draggedItemId: treeState.draggedItem?.id, // Added
                isDragging: treeState.isDragging, // Added
                hoveredTargetId: treeState.hoveredTargetId, // Added
                isHoverTargetValid: treeState.isHoverTargetValid, // Added
                // --- Callbacks connected to notifier ---
                onItemSelected: notifier.selectItem,
                onToggleExpand: notifier.toggleExpand,
                onItemDoubleClicked: (item) {
                  // Handle double click - potentially call CardManager
                  // Consider using ref.read for CardManager if it's a provider
                  // final manager = cardManager ?? ProviderScope.containerOf(context).read(cardManagerProvider); // Example if CardManager is a provider - Commented out to fix error
                  // Or handle null case if CardManager is optional and not provided
                  // if (manager != null) {
                  //    manager.addCard(NoteCard(noteId: item.id), flexFactor: 3);
                  // }
                  // TODO: Replace Provider.of with a Riverpod-friendly way to access CardManager
                  // For now, assuming cardManager is passed or available via context extension/provider
                  final resolvedCardManager = cardManager; // Simplified for now
                  if (resolvedCardManager != null) {
                    // Need to define NoteCard or import it
                    // resolvedCardManager.addCard(NoteCard(noteId: item.id), flexFactor: 3);
                    print("TODO: Implement opening NoteCard for ${item.id}");
                  } else {
                    print("CardManager not available to open NoteCard");
                  }
                },
                onAddChildNote: (item) async {
                  final formResult = await _showAddNoteDialog(context);
                  final title = formResult?['title'] as String?;
                  if (title != null && title.isNotEmpty) {
                    _showLoadingDialog(context, 'Creating note...');
                    final successId = await notifier.addChildNote(item, title);
                    _hideLoadingDialog(context);
                    if (successId != null) {
                      _showSuccessSnackBar(context, 'Note "$title" created');
                    } else {
                      _showErrorSnackBar(context, 'Failed to create note');
                    }
                  }
                },
                onDeleteNote: (item) async {
                  final confirm =
                      await _showDeleteConfirmDialog(context, item.name);
                  if (confirm) {
                    _showLoadingDialog(context, 'Deleting note...');
                    final success = await notifier.deleteNote(item);
                    _hideLoadingDialog(context);
                    if (success) {
                      _showSuccessSnackBar(
                          context, 'Note "${item.name}" deleted');
                    } else {
                      _showErrorSnackBar(context, 'Failed to delete note');
                    }
                  }
                },
                // --- Drag and Drop Callbacks ---
                onStartDrag: notifier.startDrag,
                onEndDrag: notifier.endDrag,
                onHoverTarget: notifier.hoverTarget, // Added
                onLeaveTarget: notifier.leaveTarget, // Added
                onDropNote: (targetItem) async {
                  // Renamed from onDropNote to match view
                  _showLoadingDialog(context, 'Moving note...');
                  final success = await notifier.moveNote(targetItem);
                  _hideLoadingDialog(context);
                  if (success) {
                    _showSuccessSnackBar(context, 'Note moved successfully');
                  } else {
                    _showErrorSnackBar(context, 'Failed to move note');
                  }
                },
                // Removed: canAcceptDrop
              ),
              // Refresh Button
              Positioned(
                bottom: 8, // Adjust position as needed
                right: 8,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Refresh'),
                  // Use notifier's refresh method
                  onPressed: () => notifier.refreshTree(),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// TODO: Define or import NoteCard if needed for onItemDoubleClicked
// TODO: Define or import cardManagerProvider if CardManager is managed by Riverpod
// Example Provider definition (place appropriately):
// final cardManagerProvider = Provider<CardManager>((ref) => throw UnimplementedError());
