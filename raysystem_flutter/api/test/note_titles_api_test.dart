import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

/// tests for NoteTitlesApi
void main() {
  final instance = Openapi().getNoteTitlesApi();

  group(NoteTitlesApi, () {
    // Add Note Title
    //
    // Add a new title to a note
    //
    //Future<NoteTitleResponse> addNoteTitleNotesNoteIdTitlesPost(int noteId, NoteTitleCreate noteTitleCreate) async
    test('test addNoteTitleNotesNoteIdTitlesPost', () async {
      // TODO
    });

    // Delete Note Title
    //
    // Delete a note title  Note: Cannot delete a note's only title or its primary title
    //
    //Future<bool> deleteNoteTitleNotesTitlesTitleIdDelete(int titleId) async
    test('test deleteNoteTitleNotesTitlesTitleIdDelete', () async {
      // TODO
    });

    // Get Note Titles
    //
    // Get all titles for a note
    //
    //Future<BuiltList<NoteTitleResponse>> getNoteTitlesNotesNoteIdTitlesGet(int noteId) async
    test('test getNoteTitlesNotesNoteIdTitlesGet', () async {
      // TODO
    });

    // Update Note Title
    //
    // Update an existing note title
    //
    //Future<NoteTitleResponse> updateNoteTitleNotesTitlesTitleIdPut(int titleId, NoteTitleUpdate noteTitleUpdate) async
    test('test updateNoteTitleNotesTitlesTitleIdPut', () async {
      // TODO
    });
  });
}
