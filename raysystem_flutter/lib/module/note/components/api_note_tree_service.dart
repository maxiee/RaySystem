import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'note_tree_model.dart';
import 'note_tree_service.dart';

/// Implementation of NoteTreeService that uses the API client to fetch real note data
class ApiNoteTreeService implements NoteTreeService {
  /// API client for notes
  final NotesApi _notesApi;
  
  /// In-memory cache for notes
  final Map<String, List<NoteTreeItem>> _cache = {};
  
  /// Root folder ID for the tree structure
  static const String rootFolderId = 'root';
  
  /// Flag for debug messages
  final bool _debug;
  
  /// Icons for notes and folders
  final IconData _noteIcon;
  final IconData _folderIcon;
  final IconData _folderOpenIcon;

  /// Creates a new ApiNoteTreeService with the provided API client
  ApiNoteTreeService({
    required NotesApi notesApi,
    bool debug = false,
    IconData noteIcon = Icons.description,
    IconData folderIcon = Icons.folder,
    IconData folderOpenIcon = Icons.folder_open,
  }) : _notesApi = notesApi,
       _debug = debug,
       _noteIcon = noteIcon,
       _folderIcon = folderIcon,
       _folderOpenIcon = folderOpenIcon;

  @override
  Future<List<NoteTreeItem>> getInitialItems() async {
    _logDebug('Fetching initial items');
    
    // Check cache first
    if (_cache.containsKey(rootFolderId)) {
      _logDebug('Returning ${_cache[rootFolderId]!.length} cached root items');
      return List.from(_cache[rootFolderId]!);
    }
    
    try {
      // Fetch notes from API
      final response = await _notesApi.listRecentNotesNotesGet(limit: 50);
      final notes = response.data?.items.toList() ?? [];
      
      // Convert API notes to NoteTreeItems
      final rootItems = _convertApiNotesToTreeItems(notes, 0);
      
      // Cache the result
      _cache[rootFolderId] = rootItems;
      
      _logDebug('Fetched ${rootItems.length} root items');
      return rootItems;
    } catch (e) {
      _logDebug('Error fetching initial items: $e');
      return [];
    }
  }

  @override
  Future<List<NoteTreeItem>> getChildrenFor(String parentId) async {
    _logDebug('Fetching children for folder ID: $parentId');
    
    // Check cache first
    if (_cache.containsKey(parentId)) {
      _logDebug('Returning ${_cache[parentId]!.length} cached items for $parentId');
      return List.from(_cache[parentId]!);
    }
    
    try {
      // In a real implementation, you would fetch children notes based on the parent ID
      // For example, an API call like: _notesApi.getChildNotes(parentId);
      
      // For now, return empty list as we don't have a specific API endpoint for this
      // This would be replaced with actual API calls based on your backend structure
      return [];
    } catch (e) {
      _logDebug('Error fetching children for $parentId: $e');
      return [];
    }
  }

  @override
  Future<bool> hasChildren(String folderId) async {
    _logDebug('Checking if folder $folderId has children');
    
    // If we have cache data, use that
    if (_cache.containsKey(folderId)) {
      return _cache[folderId]!.isNotEmpty;
    }
    
    try {
      // Find the item in all cached items to check if it's a folder
      bool isFolder = false;
      
      // Check in root items first
      if (_cache.containsKey(rootFolderId)) {
        for (var item in _cache[rootFolderId]!) {
          if (item.id == folderId && item.isFolder) {
            isFolder = true;
            break;
          }
        }
      }
      
      // If not found in root, check in all other cached folders
      if (!isFolder) {
        for (var cacheKey in _cache.keys) {
          if (cacheKey != rootFolderId) {
            for (var item in _cache[cacheKey]!) {
              if (item.id == folderId && item.isFolder) {
                isFolder = true;
                break;
              }
            }
            if (isFolder) break;
          }
        }
      }
      
      // For folders, assume they might have children until proven otherwise
      return isFolder;
    } catch (e) {
      _logDebug('Error checking children for $folderId: $e');
      return false;
    }
  }

  @override
  void resetCache() {
    _logDebug('Resetting cache');
    _cache.clear();
  }
  
  /// Converts API note responses to NoteTreeItem objects
  List<NoteTreeItem> _convertApiNotesToTreeItems(List<NoteResponse> notes, int level) {
    return notes.map((note) {
      // Determine if it's a folder based on the note properties
      // This is a placeholder - your actual logic would depend on your API structure
      final bool isFolder = note.title?.endsWith('/') ?? false;
      
      return NoteTreeItem(
        id: 'note_${note.id}',
        name: note.title ?? 'Untitled Note',
        isFolder: isFolder,
        level: level,
        icon: isFolder ? _folderIcon : _noteIcon,
        children: [], // Empty for lazy loading
      );
    }).toList();
  }

  /// Simple debug logging function
  void _logDebug(String message) {
    if (_debug) {
      debugPrint('📁 ApiTreeService: $message');
    }
  }
}