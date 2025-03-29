import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:openapi/openapi.dart';
import 'package:raysystem_flutter/module/note/api/note/api_note_service.dart';

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
  final ApiNoteService _noteService = ApiNoteService();

  late TextEditingController _titleController;
  EditorState? _editorState;
  EditorScrollController? _editorScrollController;
  bool _isNew = false;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;

  late NoteResponse originNote;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
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
    _titleController.dispose();
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

    setState(() {
      originNote = loadedNote!;
    });

    // 再次检查组件是否还挂载
    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (loadedNote != null) {
      _updateUIFromNote(loadedNote);
    } else {
      setState(() {
        _errorMessage = '加载笔记失败';
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
      _editorScrollController =
          EditorScrollController(editorState: _editorState!);
    } catch (e) {
      debugPrint('Error parsing note content: $e');
      _initializeEmptyEditor();
    }
  }

  void _initializeEmptyEditor() {
    // 避免使用 Document.empty()，直接创建一个最基本的空文档
    _editorState = EditorState.blank();
    _editorScrollController =
        EditorScrollController(editorState: _editorState!);
  }

  Future<void> _saveNote() async {
    if (_editorState == null) return;

    setState(() {
      _isSaving = true;
    });

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
        final note = await _noteService.createNote(
          title: finalTitle,
          contentAppflowy: contentAppflowy,
        );

        success = note != null;

        if (success && mounted) {
          // 保存返回的笔记 ID，用于后续更新操作
          setState(() {
            originNote = note;
            _isNew = false; // 标记为不再是新笔记
          });

          debugPrint('Note created with ID: ${originNote.id}');
        }
      } else {
        // 确保我们有有效的笔记 ID 用于更新
        if (widget.noteId == null) {
          throw StateError("Cannot update note: note ID is null");
        }

        final parentId = originNote.parentId;

        // Update existing note, passing the parent ID to preserve the relationship
        success = await _noteService.updateNote(
          noteId: originNote.id,
          title: finalTitle,
          contentAppflowy: contentAppflowy,
          parentId: parentId, // Preserve parent-child relationship
        );

        debugPrint(
            'Note updated with ID: ${originNote.id}, parentId: $parentId');
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            hintText: 'Note Title',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          style: Theme.of(context).textTheme.headlineSmall,
          readOnly: !widget.isEditable,
        ),
        const Divider(),
        Expanded(
          child: Padding(
            // 减少水平方向的内边距，让编辑区域更宽
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _editorState != null && _editorScrollController != null
                ? widget.isEditable
                    ? FloatingToolbar(
                        items: [
                          paragraphItem,
                          ...headingItems,
                          ...markdownFormatItems,
                          quoteItem,
                          bulletedListItem,
                          numberedListItem,
                          linkItem,
                          buildTextColorItem(),
                          buildHighlightColorItem(),
                          ...textDirectionItems,
                          ...alignmentItems
                        ],
                        textDirection: TextDirection.ltr,
                        editorState: _editorState!,
                        editorScrollController: _editorScrollController!,
                        child: AppFlowyEditor(
                          editorState: _editorState!,
                          editorScrollController: _editorScrollController,
                          editable: widget.isEditable,
                          shrinkWrap: false,
                          // 自定义样式设置，使用 LXGW WenKai Mono 字体
                          editorStyle: EditorStyle.desktop(
                            padding: EdgeInsets.zero,
                            textStyleConfiguration: TextStyleConfiguration(
                              text: TextStyle(
                                fontFamily: 'LXGW WenKai',
                                fontSize: 16,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              ),
                            ),
                          ),
                        ),
                      )
                    : AppFlowyEditor(
                        editorState: _editorState!,
                        editorScrollController: _editorScrollController,
                        editable: widget.isEditable,
                        shrinkWrap: false,
                        // 自定义样式设置，使用 LXGW WenKai Mono 字体
                        editorStyle: EditorStyle.desktop(
                          padding: EdgeInsets.zero,
                          textStyleConfiguration: TextStyleConfiguration(
                            text: TextStyle(
                              fontFamily: 'LXGW WenKai',
                              fontSize: 16,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      )
                : const Center(child: CircularProgressIndicator()),
          ),
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
