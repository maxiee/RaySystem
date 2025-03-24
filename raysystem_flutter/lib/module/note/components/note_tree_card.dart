import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_manager.dart';
import 'package:raysystem_flutter/card/note_card.dart';
import 'package:raysystem_flutter/form/form_field.dart';
import 'package:raysystem_flutter/form/form_manager.dart';
import 'package:raysystem_flutter/module/note/components/note_tree_view.dart';
import 'package:raysystem_flutter/module/note/components/note_tree_model.dart';
import 'package:raysystem_flutter/module/note/providers/notes_provider.dart';
import 'note_tree_service.dart';
import '../api/mock_note_tree_service.dart';

/// A card widget that displays a note tree explorer
class NoteTreeCard extends StatefulWidget {
  /// Optional tree service to use instead of the default mock service
  final NoteTreeService? treeService;
  
  /// 卡片管理器，用于添加新卡片
  final CardManager? cardManager;

  const NoteTreeCard({
    Key? key,
    this.treeService,
    this.cardManager,
  }) : super(key: key);

  @override
  State<NoteTreeCard> createState() => _NoteTreeCardState();
}

class _NoteTreeCardState extends State<NoteTreeCard> {
  NoteTreeItem? _selectedItem;

  // Create a service instance - using provided one or creating a mock
  late final NoteTreeService _noteTreeService;

  // Tree view key to access methods like refreshChildren
  final GlobalKey<NoteTreeViewClassicState> _treeViewKey = GlobalKey();

  // We no longer need to preload the items, we'll let the tree view handle it
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _noteTreeService = widget.treeService ?? MockNoteTreeService();
  }

  void _handleItemSelected(NoteTreeItem item) {
    setState(() {
      _selectedItem = item;
    });
  }
  
  // 处理双击笔记事件 - 添加到CardManager
  void _handleItemDoubleClicked(NoteTreeItem item) {
    // 确保有可用的CardManager
    final cardManager = widget.cardManager ?? Provider.of<CardManager>(context, listen: false);
    
    // 添加新的笔记卡片到卡片流
    cardManager.addCard(
      SizedBox(
        height: 400,
        child: NoteCard(
          noteId: item.id,
          isEditable: true,
        ),
      ),
    );
  }

  // Handle adding a child note to the selected parent
  Future<void> _handleAddChildNote(NoteTreeItem parentItem) async {
    // Get the notes provider
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);

    // Show dialog to get note title
    final formResult = await _showAddNoteDialog(context);
    
    // Get the title from the form result
    final newNoteTitle = formResult?['title'] as String?;
    
    // If user cancelled, return
    if (newNoteTitle == null || newNoteTitle.isEmpty) return;

    // Show loading indicator
    _showLoadingDialog(context, 'Creating note...');

    try {
      // Create a new note with the parent ID set to the selected item's ID
      final newNoteId = await notesProvider.createNote(
        title: newNoteTitle,
        contentAppflowy: '{"document":{"type":"page","children":[{"type":"paragraph","content":[{"type":"text","text":""}]}]}}',
        parentId: parentItem.id,
      );

      // Hide loading dialog
      Navigator.of(context).pop();

      if (newNoteId != null) {
        // If successful, mark the parent as a folder if it wasn't already
        if (!parentItem.isFolder) {
          // Update the parent in the tree to show it as a folder
          parentItem.isFolder = true;
        }

        // Refresh the children of the parent note to show the new child
        if (_treeViewKey.currentState != null) {
          await _treeViewKey.currentState!.refreshChildren(parentItem.id);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Note "$newNoteTitle" created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _showErrorSnackBar('Failed to create note');
      }
    } catch (e) {
      // Hide loading dialog if still showing
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _showErrorSnackBar('Error creating note: ${e.toString()}');
    }
  }

  // Show a dialog to get the title for the new note using FormManager
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

  // Show a loading dialog
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

  // Show an error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 3.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.folder,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Notes Explorer',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (_selectedItem != null)
                  Text(
                    'Selected: ${_selectedItem!.name}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),

          // Tree View
          Expanded(
            child: Stack(
              children: [
                NoteTreeViewClassic(
                  key: _treeViewKey,
                  // Pass the abstract service to the tree view
                  treeService: _noteTreeService,
                  autoLoadInitialData: true,
                  onItemSelected: _handleItemSelected,
                  onAddChildNote: _handleAddChildNote,
                  onItemDoubleClicked: _handleItemDoubleClicked,
                ),

                // Show an overlay loading indicator during refresh
                if (_isRefreshing)
                  Container(
                    color: Colors.black12,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),

          // Actions bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Refresh'),
                  onPressed: _isRefreshing
                      ? null
                      : () {
                          setState(() {
                            _isRefreshing = true;

                            // Reset the service cache
                            _noteTreeService.resetCache();

                            // We need to rebuild to create a new tree view with empty initial items
                            Future.delayed(const Duration(milliseconds: 300),
                                () {
                              setState(() {
                                _isRefreshing = false;
                              });
                            });
                          });
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
