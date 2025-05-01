// filepath: /Volumes/ssd/Code/RaySystem/raysystem_flutter/lib/module/note/components/note_tree/notifier/note_tree.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_facade.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_state.dart';
import 'package:raysystem_flutter/module/note/model/note_tree_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// 兼容层，保持与原始NoteTree API兼容，但内部委托给分离的功能模块
class NoteTree extends AsyncNotifier<NoteTreeState> {
  // --- Expansion ---
  Future<void> toggleExpand(NoteTreeItem item) =>
      ref.read(noteTreeFacadeProvider.notifier).toggleExpand(item);

  // --- Drag and Drop ---
  void startDrag(NoteTreeItem item) =>
      ref.read(noteTreeFacadeProvider.notifier).startDrag(item);
  void endDrag() => ref.read(noteTreeFacadeProvider.notifier).endDrag();
  Future<void> hoverTarget(NoteTreeItem targetItem) =>
      ref.read(noteTreeFacadeProvider.notifier).hoverTarget(targetItem);
  void leaveTarget() => ref.read(noteTreeFacadeProvider.notifier).leaveTarget();
  Future<bool> moveNote(NoteTreeItem targetItem) =>
      ref.read(noteTreeFacadeProvider.notifier).moveNote(targetItem);

  // --- CRUD Operations ---
  Future<int?> addChildNote(NoteTreeItem parentItem, String title) =>
      ref.read(noteTreeFacadeProvider.notifier).addChildNote(parentItem, title);
  Future<bool> deleteNote(NoteTreeItem item) =>
      ref.read(noteTreeFacadeProvider.notifier).deleteNote(item);

  // --- Refreshing ---
  Future<void> refreshTree(
          {bool preserveExpansion = false, Set<int>? ensureExpanded}) =>
      ref.read(noteTreeFacadeProvider.notifier).refreshTree(
          preserveExpansion: preserveExpansion, ensureExpanded: ensureExpanded);
}
