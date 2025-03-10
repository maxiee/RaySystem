import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:openapi/openapi.dart';
import '../app/providers/notes_provider.dart';

class NoteCard extends StatefulWidget {
  final int? noteId; // Null for a new note
  final bool isEditable;

  const NoteCard({
    Key? key,
    this.noteId,
    this.isEditable = true,
  }) : super(key: key);

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late TextEditingController _titleController;
  EditorState? _editorState;
  bool _isNew = false;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  // 保存笔记 ID，用于在创建后的更新操作
  int? _currentNoteId;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _isNew = widget.noteId == null;
    _currentNoteId = widget.noteId; // 初始化为传入的 ID

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
    _titleController.dispose();
    super.dispose();
  }

  void _loadNote() async {
    if (_currentNoteId == null) return;

    final notesProvider = Provider.of<NotesProvider>(context, listen: false);

    // Check if we already have the note in the provider
    final existingNote = notesProvider.getNoteById(_currentNoteId!);
    if (existingNote != null) {
      _updateUIFromNote(existingNote.note);
      setState(() {
        _isLoading = false;
      });
    } else {
      // Fetch the note if not already available
      await notesProvider.fetchNote(_currentNoteId!);

      // Check if note was loaded successfully
      final loadedNote = notesProvider.getNoteById(_currentNoteId!);
      if (loadedNote != null) {
        _updateUIFromNote(loadedNote.note);
      } else {
        setState(() {
          _errorMessage = 'Failed to load note';
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateUIFromNote(NoteResponse note) {
    _titleController.text = note.title;

    // Convert AppFlowy JSON string to editor document
    try {
      final document = Document.fromJson(note.contentAppflowy.isEmpty
          ? {
              'document': {'type': 'page', 'children': []}
            }
          : {'document': jsonDecode(note.contentAppflowy)});
      _editorState = EditorState(document: document);
    } catch (e) {
      debugPrint('Error parsing note content: $e');
      _initializeEmptyEditor();
    }
  }

  void _initializeEmptyEditor() {
    // 避免使用 Document.empty()，直接创建一个最基本的空文档
    _editorState = EditorState.blank();
  }

  Future<void> _saveNote() async {
    if (_editorState == null) return;

    setState(() {
      _isSaving = true;
    });

    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    final title = _titleController.text.trim();

    // If title is empty, use a default title
    final finalTitle = title.isEmpty ? 'Untitled Note' : title;

    // Convert editor document to JSON string
    final contentJson = _editorState!.document.toJson();
    final contentAppflowy = jsonEncode(contentJson['document']);

    try {
      bool success;
      if (_isNew) {
        // Create new note
        final noteId = await notesProvider.createNote(
          title: finalTitle,
          contentAppflowy: contentAppflowy,
        );

        success = noteId != null;

        if (success && mounted) {
          // 保存返回的笔记 ID，用于后续更新操作
          setState(() {
            _currentNoteId = noteId;
            _isNew = false; // 标记为不再是新笔记
          });

          debugPrint('Note created with ID: $_currentNoteId');
        }
      } else {
        // 确保我们有有效的笔记 ID 用于更新
        if (_currentNoteId == null) {
          throw StateError("Cannot update note: note ID is null");
        }

        // Update existing note
        success = await notesProvider.updateNote(
          noteId: _currentNoteId!,
          title: finalTitle,
          contentAppflowy: contentAppflowy,
        );

        debugPrint('Note updated with ID: $_currentNoteId');
      }

      if (mounted) {
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save note')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(_isNew
                    ? 'Note created successfully'
                    : 'Note updated successfully')),
          );
        }
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 3.0,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildNoteContent(),
    );
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Note Title',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: Theme.of(context).textTheme.headlineSmall,
            readOnly: !widget.isEditable,
          ),
        ),
        const Divider(),
        Expanded(
          child: _editorState != null
              ? AppFlowyEditor(
                  editorState: _editorState!,
                  editable: widget.isEditable,
                  shrinkWrap: false,
                )
              : const Center(child: CircularProgressIndicator()),
        ),
        if (widget.isEditable)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveNote,
              child: _isSaving
                  ? const CircularProgressIndicator.adaptive()
                  : Text(_isNew ? '创建笔记' : '更新笔记'),
            ),
          ),
      ],
    );
  }
}
