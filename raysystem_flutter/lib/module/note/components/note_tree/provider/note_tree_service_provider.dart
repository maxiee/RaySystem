import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/api/api.dart';
import 'package:raysystem_flutter/module/note/api/note_tree/api_note_tree_service.dart';
import 'package:raysystem_flutter/module/note/api/note_tree/note_tree_service.dart';

final noteTreeServiceProvider = Provider<NoteTreeService>((ref) {
  return ApiNoteTreeService(notesApi: notesApi);
});
