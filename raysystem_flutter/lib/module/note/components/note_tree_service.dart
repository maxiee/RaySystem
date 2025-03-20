import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

import 'api_note_tree_service.dart';
import 'mock_note_tree_service.dart';
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
  
  /// Factory method to create a NoteTreeService implementation
  /// 
  /// If [useMock] is true, returns a MockNoteTreeService
  /// Otherwise returns an ApiNoteTreeService using the provided [notesApi]
  /// 
  /// [debug] enables debug logging in both implementations
  static NoteTreeService create({
    required bool useMock,
    NotesApi? notesApi,
    bool debug = false,
    IconData noteIcon = Icons.description,
    IconData folderIcon = Icons.folder,
    IconData folderOpenIcon = Icons.folder_open,
  }) {
    if (useMock) {
      return MockNoteTreeService();
    }
    
    assert(notesApi != null, 'notesApi must be provided when useMock is false');
    
    return ApiNoteTreeService(
      notesApi: notesApi!,
      debug: debug,
      noteIcon: noteIcon,
      folderIcon: folderIcon,
      folderOpenIcon: folderOpenIcon,
    );
  }
}