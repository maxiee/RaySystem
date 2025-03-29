import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:raysystem_flutter/api/api.dart';
import 'package:raysystem_flutter/module/note/api/note/note_service.dart';

class ApiNoteService implements NoteService {
  @override
  Future<NoteResponse?> fetchNote(int noteId) async {
    try {
      final response = await notesApi.getNoteNotesNoteIdGet(noteId: noteId);
      if (response.statusCode == 200) {
        // Parse the response body
        return response.data;
      } else {
        // Handle error
        debugPrint('Error fetching note: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      debugPrint('Error fetching note: $e');
    }
    return null;
  }

  @override
  Future<int?> createNote(
      {required String title, required String contentAppflowy, int? parentId}) {
    // TODO: implement createNote
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteNote(int noteId) {
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<void> searchNotes(String query) {
    // TODO: implement searchNotes
    throw UnimplementedError();
  }

  @override
  Future<bool> updateNote(
      {required int noteId,
      required String title,
      required String contentAppflowy,
      int? parentId}) {
    // TODO: implement updateNote
    throw UnimplementedError();
  }
}
