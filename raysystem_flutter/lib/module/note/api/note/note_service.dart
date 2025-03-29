import 'package:openapi/openapi.dart';

abstract class NoteService {
  // Get a specific note by ID
  Future<NoteResponse?> fetchNote(int noteId);

  // Create a new note
  Future<NoteResponse?> createNote(
      {required String title, required String contentAppflowy, int? parentId});

  // Update an existing note
  Future<NoteResponse?> updateNote(
      {required int noteId,
      required String title,
      required String contentAppflowy,
      int? parentId});

  // Delete a note
  Future<bool> deleteNote(int noteId);

  // Search notes by title
  Future<void> searchNotes(String query);
}
