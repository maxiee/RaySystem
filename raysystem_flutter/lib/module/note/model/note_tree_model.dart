import 'package:flutter/material.dart';

/// Model representing a single item in the note tree
class NoteTreeItem {
  /// Unique identifier for the note
  final int id;

  /// Display name in the tree
  final String name;

  /// Whether this is a folder (true) or a note (false)
  bool isFolder;

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
    int? id,
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