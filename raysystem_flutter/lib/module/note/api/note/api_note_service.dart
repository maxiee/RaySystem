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
  Future<NoteResponse?> createNote(
      {required String title,
      required String contentAppflowy,
      int? parentId}) async {
    try {
      final noteCreate = NoteCreate((b) => b
        ..title = title
        ..contentAppflowy = contentAppflowy
        ..parentId = parentId);

      final response =
          await notesApi.createNoteNotesPost(noteCreate: noteCreate);
      if (response.statusCode == 200) {
        // Parse the response body
        return response.data;
      } else {
        // Handle error
        debugPrint('Error creating note: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error creating note: $e');
    }
    return null;
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
  Future<NoteResponse?> updateNote(
      {required int noteId,
      required String title,
      required String contentAppflowy,
      int? parentId}) async {
    try {
      final noteUpdate = NoteUpdate((b) => b
        ..title = title
        ..contentAppflowy = contentAppflowy
        ..parentId = parentId);

      final response = await notesApi.updateNoteNotesNoteIdPut(
        noteId: noteId,
        noteUpdate: noteUpdate,
      );
      if (response.statusCode == 200) {
        // Parse the response body
        return response.data;
      } else {
        // Handle error
        debugPrint('Error updating note: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating note: $e');
    }
    return null;
  }
}
