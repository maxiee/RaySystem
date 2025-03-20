import 'note_tree_model.dart';

/// Abstract interface for note tree data services
abstract class NoteTreeService {
  /// Get initial/root level items
  Future<List<NoteTreeItem>> getInitialItems();

  /// Get children for a specific parent ID
  Future<List<NoteTreeItem>> getChildrenFor(String parentId);

  /// Check if a folder has any children
  Future<bool> hasChildren(String folderId);

  /// Reset the cache (optional implementation)
  void resetCache() {}
}