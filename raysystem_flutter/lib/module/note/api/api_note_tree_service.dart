import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import '../components/note_tree_model.dart';
import '../components/note_tree_service.dart';

/// Implementation of NoteTreeService that uses the API client to fetch real note data
class ApiNoteTreeService implements NoteTreeService {
  /// API client for notes
  final NotesApi _notesApi;
  
  /// In-memory cache for notes
  final Map<int?, List<NoteTreeItem>> _cache = {};
  
  /// Flag for debug messages
  final bool _debug;
  
  /// Icons for notes
  final IconData _noteIcon;
  final IconData _expandedNoteIcon;
  final IconData _collapsedNoteIcon;

  /// Creates a new ApiNoteTreeService with the provided API client
  ApiNoteTreeService({
    required NotesApi notesApi,
    bool debug = false,
    IconData noteIcon = Icons.description,
    IconData collapsedNoteIcon = Icons.folder,
    IconData expandedNoteIcon = Icons.folder_open,
  }) : _notesApi = notesApi,
       _debug = debug,
       _noteIcon = noteIcon,
       _collapsedNoteIcon = collapsedNoteIcon,
       _expandedNoteIcon = expandedNoteIcon;

  @override
  Future<List<NoteTreeItem>> getInitialItems() async {
    _logDebug('Fetching initial items');
    
    // Check cache first
    if (_cache.containsKey(0)) {
      _logDebug('Returning ${_cache[0]!.length} cached root items');
      return List.from(_cache[0]!);
    }
    
    try {
      // Fetch root notes directly using the getChildrenFor method
      return await getChildrenFor(0);
    } catch (e) {
      _logDebug('Error fetching initial items: $e');
      return [];
    }
  }

  @override
  Future<List<NoteTreeItem>> getChildrenFor(int? parentId) async {
    _logDebug('Fetching children for parent ID: ${parentId ?? "root (null)"}');
    
    // Check cache first
    if (_cache.containsKey(parentId)) {
      _logDebug('Returning ${_cache[parentId]!.length} cached items for ${parentId ?? "root (null)"}');
      return List.from(_cache[parentId]!);
    }
    
    try {
      final response = await _notesApi.getChildNotesNotesTreeChildrenGet(
        parentId: parentId, // null represents root level notes in the API
        limit: 50,
      );
      
      final noteNodes = response.data?.items.toList() ?? [];
      
      // Determine the level for these items
      int parentLevel = 0;
      if (parentId != null) {
        // Try to find parent level in cached items
        for (var entries in _cache.entries) {
          for (var item in entries.value) {
            if (item.id == parentId) {
              parentLevel = item.level;
              break;
            }
          }
        }
      }
      
      final items = _convertNoteTreeNodesToTreeItems(noteNodes, parentLevel + 1);
      
      // Cache the result
      _cache[parentId] = items;
      _logDebug('Fetched ${items.length} items for parent ${parentId ?? "root (null)"}');
      return items;
    } catch (e) {
      _logDebug('Error fetching children for ${parentId ?? "root (null)"}: $e');
      return [];
    }
  }

  /// Converts NoteTreeNode objects from API to NoteTreeItem objects for the UI
  List<NoteTreeItem> _convertNoteTreeNodesToTreeItems(List<NoteTreeNode> nodes, int level) {
    return nodes.map((node) {
      final hasChildren = node.hasChildren ?? false;
      return NoteTreeItem(
        id: node.id!,
        name: node.title ?? 'Untitled',
        isFolder: hasChildren, // A note with children can be expanded like a folder
        level: level,
        icon: hasChildren ? _collapsedNoteIcon : _noteIcon,
        children: [], // Empty for lazy loading
      );
    }).toList();
  }

  @override
  Future<bool> hasChildren(int? noteId) async {
    _logDebug('Checking if note $noteId has children');
    
    // If we have cache data, use that
    for (var cacheEntry in _cache.entries) {
      if (cacheEntry.value.any((item) => item.id == noteId && item.isFolder)) {
        return true;
      }
    }
    
    try {      
      // Check if the note has any children
      final response = await _notesApi.getChildNotesNotesTreeChildrenGet(
        parentId: noteId,
        limit: 1,
      );
      
      final hasChildren = (response.data?.items.length ?? 0) > 0;
      _logDebug('Note $noteId has children: $hasChildren');
      return hasChildren;
    } catch (e) {
      _logDebug('Error checking children for $noteId: $e');
      return false;
    }
  }

  @override
  void resetCache() {
    _logDebug('Resetting cache');
    _cache.clear();
  }
  
  /// Simple debug logging function
  void _logDebug(String message) {
    if (_debug) {
      debugPrint('📝 ApiNoteTreeService: $message');
    }
  }
}