import 'dart:async';
import 'package:flutter/material.dart';
import 'note_tree_model.dart';
import 'note_tree_service.dart';

/// Service to provide mock tree data with simulated network delays
class MockNoteTreeService implements NoteTreeService {
  /// In-memory cache of the entire tree structure for mock data purposes
  final Map<String, List<NoteTreeItem>> _mockTreeCache = {};

  /// Flag to print debug info
  final bool _debug = true;

  MockNoteTreeService() {
    // Initialize mock data cache with the full tree structure
    _initializeMockData();
  }

  /// Initialize the mock data cache with a complete tree structure
  void _initializeMockData() {
    List<NoteTreeItem> mockData = MockNoteTreeData.generateMockData();
    _logDebug('Initializing mock data with ${mockData.length} root items');

    // Cache root level items
    _mockTreeCache['root'] = mockData
        .map((item) => item.copyWith(
              children: [], // Empty children array for lazy loading
            ))
        .toList();

    // Cache all children by parent ID
    _cacheChildren(mockData);

    // Print cache keys for debugging
    _logDebug('Cache initialized with keys: ${_mockTreeCache.keys.toList()}');
  }

  @override
  void resetCache() {
    _logDebug('Resetting cache');
    _mockTreeCache.clear();
    _initializeMockData();
  }

  /// Recursively cache all children by parent ID
  void _cacheChildren(List<NoteTreeItem> items) {
    for (var item in items) {
      if (item.isFolder && item.children.isNotEmpty) {
        // Cache this folder's children
        _mockTreeCache[item.id] = item.children;
        _logDebug(
            'Cached ${item.children.length} children for folder ${item.id} (${item.name})');

        // Recursively cache grandchildren
        _cacheChildren(item.children);
      }
    }
  }

  @override
  Future<List<NoteTreeItem>> getInitialItems() async {
    // Simulate network delay (shorter for initial load)
    await Future.delayed(const Duration(milliseconds: 300));

    if (!_mockTreeCache.containsKey('root')) {
      _logDebug('Warning: Root items not found in cache');
      return [];
    }

    _logDebug('Returning ${_mockTreeCache['root']!.length} root items');

    // Return root level items without their children (for lazy loading)
    return _mockTreeCache['root']!
        .map((item) => item.copyWith(
              children: [], // Empty children array for lazy loading
            ))
        .toList();
  }

  @override
  Future<List<NoteTreeItem>> getChildrenFor(String parentId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _logDebug('Fetching children for parent ID: $parentId');

    // If no children found, return empty list
    if (!_mockTreeCache.containsKey(parentId)) {
      _logDebug('No children found for parent ID: $parentId');
      return [];
    }

    _logDebug(
        'Found ${_mockTreeCache[parentId]!.length} children for parent ID: $parentId');

    // Return children without their children (for lazy loading)
    return _mockTreeCache[parentId]!
        .map((item) => item.copyWith(
              children: [], // Empty children array for lazy loading
            ))
        .toList();
  }

  @override
  Future<bool> hasChildren(String folderId) async {
    // Simulate a quick check
    await Future.delayed(const Duration(milliseconds: 100));

    bool result = _mockTreeCache.containsKey(folderId) &&
        _mockTreeCache[folderId]!.isNotEmpty;

    _logDebug('Checking if folder $folderId has children: $result');

    return result;
  }

  /// Simple debug logging function
  void _logDebug(String message) {
    if (_debug) {
      debugPrint('📁 MockTreeService: $message');
    }
  }
}
