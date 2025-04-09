import 'package:openapi/openapi.dart';
import '../../model/note_tree_model.dart';

/// Abstract interface for note tree data services
abstract class NoteTreeService {
  /// Get initial/root level items
  Future<List<NoteTreeItem>> getInitialItems();

  /// Get children for a specific parent ID
  Future<List<NoteTreeItem>> getChildrenFor(int? parentId);

  /// Check if a folder has any children
  Future<bool> hasChildren(int? folderId);

  /// Get the NotesApi instance for direct API calls
  NotesApi? getNotesApi();

  /// Reset the cache (optional implementation)
  void resetCache() {}
}
