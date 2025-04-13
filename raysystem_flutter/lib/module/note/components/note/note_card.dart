import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/services.dart';
import 'package:openapi/openapi.dart';
import 'package:raysystem_flutter/module/editor/editor.dart';
import 'package:raysystem_flutter/module/note/api/note/api_note_service.dart';

class NoteCard extends StatefulWidget {
  final int? noteId; // Null for a new note

  const NoteCard({
    super.key,
    this.noteId,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  final ApiNoteService _noteService = ApiNoteService();

  late TextEditingController _primaryTitleController;
  EditorState? _editorState;
  EditorScrollController? _editorScrollController;
  bool _isNew = false;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  bool _showSecondaryTitles = false;

  late NoteResponse _note;
  List<NoteTitleResponse> _titles = [];

  @override
  void initState() {
    super.initState();
    _primaryTitleController = TextEditingController();
    _isNew = widget.noteId == null;

    // Load note if editing an existing one
    if (!_isNew) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadNote();
      });
    } else {
      _isLoading = false;
      // Initialize empty editor for new note
      _initializeEmptyEditor();
    }
  }

  @override
  void dispose() {
    _primaryTitleController.dispose();
    super.dispose();
  }

  void _loadNote() async {
    if (widget.noteId == null) return;

    // 确保组件仍然挂载
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    // 如果没有现有笔记，则从 API 获取
    final loadedNote = await _noteService.fetchNote(
      widget.noteId!,
    );

    // 再次检查组件是否还挂载
    if (!mounted) return;

    if (loadedNote != null) {
      setState(() {
        _note = loadedNote;
        _titles = loadedNote.noteTitles.toList();
        _isLoading = false;
      });
      _updateUIFromNote(loadedNote);
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = '家在笔记失败';
      });
    }
  }

  void _updateUIFromNote(NoteResponse note) {
    if (note.noteTitles.isEmpty) {
      _primaryTitleController.text = '未命名笔记';
    } else {
      final primaryTitle = note.noteTitles.firstWhere(
          (title) => title.isPrimary ?? false,
          orElse: () => note.noteTitles.first);

      _primaryTitleController.text = primaryTitle.title;
    }

    // Use EditorHelper to create editor state from JSON content
    try {
      _editorState = EditorHelper.createEditorFromJson(note.contentAppflowy);
      if (_editorState != null) {
        _editorScrollController =
            EditorScrollController(editorState: _editorState!);
      } else {
        _initializeEmptyEditor();
      }
    } catch (e) {
      debugPrint('Error parsing note content: $e');
      _initializeEmptyEditor();
    }
  }

  void _initializeEmptyEditor() {
    // Use EditorHelper to create empty editor
    _editorState = EditorHelper.createEmptyEditor();
    _editorScrollController =
        EditorScrollController(editorState: _editorState!);
  }

  Future<void> _saveNote() async {
    if (_editorState == null) return;

    setState(() {
      _isSaving = true;
    });

    final primaryTitle = _primaryTitleController.text.trim();
    final finalPrimaryTitle =
        primaryTitle.isEmpty ? 'Untitled Note' : primaryTitle;

    // Use EditorHelper to serialize the editor content
    final contentAppflowy = EditorHelper.serializeEditorContent(_editorState!);

    try {
      bool success;
      if (_isNew) {
        // Create new note
        final note = await _noteService.createNote(
          title: finalPrimaryTitle,
          contentAppflowy: contentAppflowy,
        );

        success = note != null;

        if (success && mounted) {
          // 保存返回的笔记 ID，用于后续更新操作
          setState(() {
            _note = note;
            _titles = note.noteTitles.toList();
            _isNew = false; // 标记为不再是新笔记
          });

          debugPrint('Note created with ID: ${_note.id}');
        }
      } else {
        // Update existing note content
        final updatedNote = await _noteService.updateNote(
            noteId: _note.id, contentAppflowy: contentAppflowy);

        // Also update the primary title if it changed
        final currentPrimaryTitle = _titles.firstWhere(
            (t) => t.isPrimary ?? false,
            orElse: () => _titles.first);
        if (currentPrimaryTitle.title != finalPrimaryTitle) {
          // Update the title via API
          await _updateNoteTitle(
              currentPrimaryTitle.id, finalPrimaryTitle, true);
        }

        success = updatedNote != null;

        if (success && mounted) {
          setState(() {
            _note = updatedNote;
            _loadNoteTitles();
          });
        }

        debugPrint(
            'Note updated with ID: ${_note.id}, parentId: ${_note.parentId}');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? (_isNew
                    ? 'Note created successfully'
                    : 'Note updated successfully')
                : 'Failed to save note'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving note: ${e.toString()}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving note: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _loadNoteTitles() async {
    if (_note == null || !mounted) return;

    try {
      final noteTitles = await _noteService.getNoteTitles(_note.id);
      if (noteTitles != null && mounted) {
        setState(() {
          _titles = noteTitles;
          // Update primary title controller
          final primaryTitle = noteTitles.firstWhere(
            (t) => t.isPrimary ?? false,
            orElse: () => noteTitles.first,
          );
          _primaryTitleController.text = primaryTitle.title;
        });
      }
    } catch (e) {
      debugPrint('Error loading note titles: $e');
    }
  }

  // Add a new title to the note
  Future<void> _addNewTitle(String title, bool isPrimary) async {
    if (_isNew || !mounted) return;

    try {
      // Note: You'll need to add this method to your ApiNoteService
      final newTitle =
          await _noteService.addNoteTitle(_note.id, title, isPrimary);
      if (newTitle != null && mounted) {
        await _loadNoteTitles();
      }
    } catch (e) {
      debugPrint('Error adding new title: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding new title: ${e.toString()}')),
        );
      }
    }
  }

  // Update an existing title
  Future<void> _updateNoteTitle(
      int titleId, String newText, bool isPrimary) async {
    if (_isNew || !mounted) return;

    try {
      // Note: You'll need to add this method to your ApiNoteService
      final updatedTitle =
          await _noteService.updateNoteTitle(titleId, newText, isPrimary);
      if (updatedTitle != null && mounted) {
        await _loadNoteTitles();
      }
    } catch (e) {
      debugPrint('Error updating title: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating title: ${e.toString()}')),
        );
      }
    }
  }

  // Delete a title
  Future<void> _deleteNoteTitle(int titleId) async {
    if (_isNew || !mounted) return;

    try {
      // Note: You'll need to add this method to your ApiNoteService
      final success = await _noteService.deleteNoteTitle(titleId);
      if (success && mounted) {
        await _loadNoteTitles();
      }
    } catch (e) {
      debugPrint('Error deleting title: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting title: ${e.toString()}')),
        );
      }
    }
  }

  // Show dialog to add a new title
  void _showAddTitleDialog() {
    final textController = TextEditingController();
    bool makePrimary = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter a new title for this note',
                ),
                autofocus: true,
              ),
              CheckboxListTile(
                title: const Text('Make primary title'),
                value: makePrimary,
                onChanged: (value) {
                  setDialogState(() {
                    makePrimary = value ?? false;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = textController.text.trim();
                if (title.isNotEmpty) {
                  _addNewTitle(title, makePrimary);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  // Show dialog to edit an existing title
  void _showEditTitleDialog(NoteTitleResponse title) {
    final textController = TextEditingController(text: title.title);
    bool makePrimary = title.isPrimary ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Title'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                autofocus: true,
              ),
              CheckboxListTile(
                title: const Text('Primary title'),
                value: makePrimary,
                onChanged: (title.isPrimary ?? false)
                    ? null
                    : (value) {
                        setDialogState(() {
                          makePrimary = value ?? false;
                        });
                      },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newText = textController.text.trim();
                if (newText.isNotEmpty) {
                  _updateNoteTitle(title.id, newText, makePrimary);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _buildNoteContent();
  }

  Widget _buildNoteContent() {
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      );
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height - 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Primary title area with UI enhancements
          _buildPrimaryTitleSection(),

          // Secondary titles section (collapsible)
          if (!_isNew) _buildSecondaryTitlesSection(),

          const Divider(),

          // Editor area
          Expanded(
            child: Padding(
              // 减少水平方向的内边距，让编辑区域更宽
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _editorState != null && _editorScrollController != null
                  ? CustomAppFlowyEditor(
                      editorState: _editorState!,
                      editorScrollController: _editorScrollController,
                      editable: true,
                      shrinkWrap: false,
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  // Move the save button to the top-right corner of the primary title section
  Widget _buildPrimaryTitleSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Primary title badge
          if (!_isNew)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '标题',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

          // Primary title text field
          Expanded(
            child: TextField(
              controller: _primaryTitleController,
              decoration: const InputDecoration(
                hintText: 'Note Title',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),

          // Save button
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveNote,
              child: _isSaving
                  ? const CircularProgressIndicator.adaptive()
                  : Text(_isNew ? '创建' : '更新'),
            ),
          ),
        ],
      ),
    );
  }

  // Build the secondary titles section (collapsible)
  Widget _buildSecondaryTitlesSection() {
    // Filter out the primary title to show only secondary titles
    final secondaryTitles = _titles.where((t) => t.isPrimary == false).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with expand/collapse toggle
        InkWell(
          onTap: () {
            setState(() {
              _showSecondaryTitles = !_showSecondaryTitles;
            });
          },
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Icon(
                  _showSecondaryTitles
                      ? Icons.keyboard_arrow_down
                      : Icons.keyboard_arrow_right,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '副标题 (${secondaryTitles.length})',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                // Add title button
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: _showAddTitleDialog,
                  tooltip: 'Add new title',
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                ),
              ],
            ),
          ),
        ),

        // Expandable list of secondary titles
        if (_showSecondaryTitles)
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
            child: secondaryTitles.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No alternative titles yet.'),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final title in secondaryTitles)
                        Chip(
                          label: GestureDetector(
                            onTap: () {
                              _showTitleOptionsMenu(title);
                            },
                            child: Text(title.title),
                          ),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () => _deleteNoteTitle(title.id),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          elevation: 0,
                          // Context menu for additional options
                          // For material 3, consider using MenuAnchor instead
                          deleteButtonTooltipMessage: 'Delete title',
                        ),
                    ],
                  ),
          ),
      ],
    );
  }

  // Show context menu for a title
  void _showTitleOptionsMenu(NoteTitleResponse title) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 'edit',
          child: const Text('Edit'),
          onTap: () {
            // Use Future.delayed to show dialog after menu is closed
            Future.delayed(Duration.zero, () => _showEditTitleDialog(title));
          },
        ),
        if (title.isPrimary == false)
          PopupMenuItem(
            value: 'make_primary',
            child: const Text('Make Primary'),
            onTap: () {
              _updateNoteTitle(title.id, title.title, true);
            },
          ),
        PopupMenuItem(
          value: 'delete',
          child: const Text('Delete'),
          onTap: () {
            _deleteNoteTitle(title.id);
          },
        ),
      ],
    );
  }
}
