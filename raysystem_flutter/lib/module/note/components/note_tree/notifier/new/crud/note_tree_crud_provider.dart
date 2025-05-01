import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/api/note_tree/note_tree_service.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/new/base/note_tree_provider.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/provider/note_tree_service_provider.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';

final noteTreeCrudProvider = Provider<NoteTreeCrudProvider>((ref) {
  return NoteTreeCrudProvider(ref);
});

class NoteTreeCrudProvider {
  final Ref _ref;

  NoteTreeCrudProvider(this._ref);

  NoteTreeService get _treeService => _ref.read(noteTreeServiceProvider);

  NoteTreeProvider get _treeNotifier => _ref.read(noteTreeProvider.notifier);

  Future<void> loadChildren(int parentId) async {
    _treeNotifier.updateChildren(
        parentId, await _treeService.getChildrenFor(parentId));
  }

  /// 添加笔记目录关系
  void addChildNote(int parentId, NoteTreeItem newChild) {
    _treeNotifier.addNote(
      newChild,
      parentId: parentId,
    );
  }

  void deleteNote(int noteId) {
    _treeNotifier.deleteNote(noteId);
  }

  Future<void> refreshingTree() async {
    _treeNotifier.resetCache();
    _treeNotifier.updateChildren(0, await _treeService.getInitialItems());
  }
}
