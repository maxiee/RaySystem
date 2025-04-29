import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart';
import 'package:raysystem_flutter/api/api_provider.dart';
import 'package:raysystem_flutter/module/note/api/note/note_service.dart';
import 'package:raysystem_flutter/module/note/components/note/provider/note_service_provider.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_base_notifier.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_facade.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_selection_notifier.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_state.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/provider/note_tree_service_provider.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';

/// 管理笔记的CRUD操作的提供者
final noteTreeCrudProvider = NotifierProvider<NoteTreeCrudNotifier, void>(
  () => NoteTreeCrudNotifier(),
);

class NoteTreeCrudNotifier extends Notifier<void> {
  NotesApi get _notesApi => ref.read(notesApiProvider);
  NoteService get _noteService => ref.read(noteServiceProvider);

  @override
  void build() {
    // 这个notifier不需要自己的状态，它只是调用其他provider
    return;
  }

  /// 添加子笔记
  Future<int?> addChildNote(NoteTreeItem parentItem, String title) async {
    try {
      final newNote = await _noteService.createNote(
        title: title,
        contentAppflowy:
            jsonEncode(EditorState.blank().document.toJson()['document']),
        parentId: parentItem.id,
      );

      if (newNote != null) {
        // 刷新树，保留展开状态并确保父项已展开
        final facadeNotifier = ref.read(noteTreeFacadeProvider.notifier);
        await facadeNotifier.refreshTree(
            preserveExpansion: true, ensureExpanded: {parentItem.id});

        return newNote.id;
      }
      return null;
    } catch (e) {
      debugPrint('Error creating note: $e');
      // 可选地，即使出错也刷新，保留展开状态
      final facadeNotifier = ref.read(noteTreeFacadeProvider.notifier);
      await facadeNotifier.refreshTree(
          preserveExpansion: true, ensureExpanded: {parentItem.id});
      return null;
    }
  }

  /// 删除笔记
  Future<bool> deleteNote(NoteTreeItem item) async {
    try {
      final response =
          await _notesApi.deleteNoteNotesNoteIdDelete(noteId: item.id);
      // ignore: unnecessary_null_comparison
      final success = response != null; // 基本检查响应是否为空

      if (success) {
        // 刷新，保留展开状态
        final facadeNotifier = ref.read(noteTreeFacadeProvider.notifier);
        await facadeNotifier.refreshTree(preserveExpansion: true);

        // 如果被删除的项目是当前选中项，则清除选择
        final selectionNotifier = ref.read(noteTreeSelectionProvider.notifier);
        selectionNotifier.handleItemDeleted(item.id);

        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting note: $e');
      // 即使出错也刷新，保留展开状态
      final facadeNotifier = ref.read(noteTreeFacadeProvider.notifier);
      await facadeNotifier.refreshTree(preserveExpansion: true);
      return false;
    }
  }
}
