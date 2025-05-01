import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/new/base/note_tree_provider.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';

final noteTreeUiProvider = Provider<NoteTreeUiProvider>((ref) {
  return NoteTreeUiProvider(ref);
});

class NoteTreeUiProvider {
  final Ref _ref;

  NoteTreeUiProvider(this._ref);

  NoteTreeProvider get _treeNotifier => _ref.read(noteTreeProvider.notifier);

  void selectNote(NoteTreeItem item) {
    _treeNotifier.setSelectedItem(item);
  }
}
