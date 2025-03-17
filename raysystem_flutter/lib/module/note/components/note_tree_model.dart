import 'package:flutter/material.dart';

/// Model representing a single item in the note tree
class NoteTreeItem {
  /// Unique identifier for the note
  final String id;

  /// Display name in the tree
  final String name;

  /// Whether this is a folder (true) or a note (false)
  final bool isFolder;

  /// Children items if this is a folder
  final List<NoteTreeItem> children;

  /// Whether this folder is expanded in the UI
  bool isExpanded;

  /// Level in the hierarchy (root = 0)
  final int level;

  /// Optional icon to display
  final IconData? icon;

  NoteTreeItem({
    required this.id,
    required this.name,
    this.isFolder = false,
    this.children = const [],
    this.isExpanded = false,
    this.level = 0,
    this.icon,
  });

  /// Creates a copy of this item with the specified fields replaced with new values
  NoteTreeItem copyWith({
    String? id,
    String? name,
    bool? isFolder,
    List<NoteTreeItem>? children,
    bool? isExpanded,
    int? level,
    IconData? icon,
  }) {
    return NoteTreeItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isFolder: isFolder ?? this.isFolder,
      children: children ?? this.children,
      isExpanded: isExpanded ?? this.isExpanded,
      level: level ?? this.level,
      icon: icon ?? this.icon,
    );
  }
}

/// Generator for mock data to populate the note tree
class MockNoteTreeData {
  /// Generates a mock tree structure for demonstration
  static List<NoteTreeItem> generateMockData() {
    return [
      NoteTreeItem(
        id: 'folder1',
        name: 'Personal Notes',
        isFolder: true,
        icon: Icons.folder,
        children: [
          NoteTreeItem(
            id: 'note1',
            name: 'My Journal.md',
            level: 1,
            icon: Icons.note,
          ),
          NoteTreeItem(
            id: 'note2',
            name: 'Goals for 2024.md',
            level: 1,
            icon: Icons.note,
          ),
          NoteTreeItem(
            id: 'folder1.1',
            name: 'Projects',
            isFolder: true,
            level: 1,
            icon: Icons.folder,
            children: [
              NoteTreeItem(
                id: 'note3',
                name: 'Project Ideas.md',
                level: 2,
                icon: Icons.note,
              ),
              NoteTreeItem(
                id: 'note4',
                name: 'Project Timeline.md',
                level: 2,
                icon: Icons.note,
              ),
            ],
          ),
        ],
      ),
      NoteTreeItem(
        id: 'folder2',
        name: 'Work',
        isFolder: true,
        icon: Icons.folder,
        children: [
          NoteTreeItem(
            id: 'note5',
            name: 'Meeting Notes.md',
            level: 1,
            icon: Icons.note,
          ),
          NoteTreeItem(
            id: 'folder2.1',
            name: 'Presentations',
            isFolder: true,
            level: 1,
            icon: Icons.folder,
            children: [
              NoteTreeItem(
                id: 'note6',
                name: 'Q1 Review.md',
                level: 2,
                icon: Icons.note,
              ),
            ],
          ),
          NoteTreeItem(
            id: 'folder2.2',
            name: 'Reports',
            isFolder: true,
            level: 1,
            icon: Icons.folder,
            children: [],
          ),
        ],
      ),
      NoteTreeItem(
        id: 'folder3',
        name: 'Learning',
        isFolder: true,
        icon: Icons.folder,
        children: [
          NoteTreeItem(
            id: 'note7',
            name: 'Flutter Concepts.md',
            level: 1,
            icon: Icons.note,
          ),
          NoteTreeItem(
            id: 'note8',
            name: 'Dart Tips.md',
            level: 1,
            icon: Icons.note,
          ),
          NoteTreeItem(
            id: 'folder3.1',
            name: 'Courses',
            isFolder: true,
            level: 1,
            icon: Icons.folder,
            children: [
              NoteTreeItem(
                id: 'folder3.1.1',
                name: 'Flutter Advanced',
                isFolder: true,
                level: 2,
                icon: Icons.folder,
                children: [
                  NoteTreeItem(
                    id: 'note9',
                    name: 'State Management.md',
                    level: 3,
                    icon: Icons.note,
                  ),
                  NoteTreeItem(
                    id: 'note10',
                    name: 'Custom Widgets.md',
                    level: 3,
                    icon: Icons.note,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
