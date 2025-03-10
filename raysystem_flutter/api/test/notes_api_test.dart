import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

/// tests for NotesApi
void main() {
  final instance = Openapi().getNotesApi();

  group(NotesApi, () {
    // Create Note
    //
    // Create a new note with title and AppFlowy editor content
    //
    //Future<NoteResponse> createNoteNotesPost(NoteCreate noteCreate) async
    test('test createNoteNotesPost', () async {
      // TODO
    });

    // Delete Note
    //
    // Delete a note by ID
    //
    //Future<bool> deleteNoteNotesNoteIdDelete(int noteId) async
    test('test deleteNoteNotesNoteIdDelete', () async {
      // TODO
    });

    // Get Note
    //
    // Get a specific note by ID
    //
    //Future<NoteResponse> getNoteNotesNoteIdGet(int noteId) async
    test('test getNoteNotesNoteIdGet', () async {
      // TODO
    });

    // List Recent Notes
    //
    // List recently updated notes sorted by update time (newest first)
    //
    //Future<NotesListResponse> listRecentNotesNotesGet({ int limit, int offset }) async
    test('test listRecentNotesNotesGet', () async {
      // TODO
    });

    // Search Notes
    //
    // Search notes by title (fuzzy search)
    //
    //Future<NotesListResponse> searchNotesNotesSearchGet(String q, { int limit, int offset }) async
    test('test searchNotesNotesSearchGet', () async {
      // TODO
    });

    // Update Note
    //
    // Update an existing note
    //
    //Future<NoteResponse> updateNoteNotesNoteIdPut(int noteId, NoteUpdate noteUpdate) async
    test('test updateNoteNotesNoteIdPut', () async {
      // TODO
    });
  });
}
