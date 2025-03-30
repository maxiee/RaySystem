import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:raysystem_flutter/api/api.dart';
import 'package:raysystem_flutter/module/note/api/note/note_service.dart';
import 'package:built_collection/built_collection.dart';

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
        ..titles = ListBuilder([
          NoteTitleCreate((b) => b
            ..title = title
            ..isPrimary = true)
        ])
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
      required String contentAppflowy,
      int? parentId}) async {
    try {
      final noteUpdate = NoteUpdate((b) => b
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

  // Get all titles for a note
  Future<List<NoteTitleResponse>?> getNoteTitles(int noteId) async {
    try {
      final response =
          await notesTitleApi.getNoteTitlesNotesNoteIdTitlesGet(noteId: noteId);
      if (response.statusCode == 200) {
        return response.data?.toList();
      } else {
        debugPrint('Error fetching note titles: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching note titles: $e');
    }
    return null;
  }

  // Add a new title to a note
  Future<NoteTitleResponse?> addNoteTitle(
      int noteId, String title, bool isPrimary) async {
    try {
      final titleCreate = NoteTitleCreate((b) => b
        ..title = title
        ..isPrimary = isPrimary);

      final response = await notesTitleApi.addNoteTitleNotesNoteIdTitlesPost(
        noteId: noteId,
        noteTitleCreate: titleCreate,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        debugPrint('Error adding note title: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error adding note title: $e');
    }
    return null;
  }

  // Update an existing title
  Future<NoteTitleResponse?> updateNoteTitle(
      int titleId, String title, bool isPrimary) async {
    try {
      final titleUpdate = NoteTitleUpdate((b) => b
        ..title = title
        ..isPrimary = isPrimary);

      final response = await notesTitleApi.updateNoteTitleNotesTitlesTitleIdPut(
        titleId: titleId,
        noteTitleUpdate: titleUpdate,
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        debugPrint('Error updating note title: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error updating note title: $e');
    }
    return null;
  }

  // Delete a title
  Future<bool> deleteNoteTitle(int titleId) async {
    try {
      final response =
          await notesTitleApi.deleteNoteTitleNotesTitlesTitleIdDelete(
        titleId: titleId,
      );

      return response.statusCode == 200 && response.data == true;
    } catch (e) {
      debugPrint('Error deleting note title: $e');
      return false;
    }
  }
}
