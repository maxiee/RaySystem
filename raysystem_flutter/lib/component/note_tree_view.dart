import 'package:flutter/material.dart';
import 'note_tree_model.dart';

class NoteTreeView extends StatefulWidget {
  final List<NoteTreeItem> items;
  final Function(NoteTreeItem)? onItemSelected;

  const NoteTreeView({
    Key? key,
    required this.items,
    this.onItemSelected,
  }) : super(key: key);

  @override
  State<NoteTreeView> createState() => _NoteTreeViewState();
}

class _NoteTreeViewState extends State<NoteTreeView> {
  String? _selectedItemId;

  // Deep copy the items to avoid modifying the original list
  late List<NoteTreeItem> _items;

  @override
  void initState() {
    super.initState();
    _initializeItems();
  }

  @override
  void didUpdateWidget(NoteTreeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _initializeItems();
    }
  }

  void _initializeItems() {
    // Create deep copies of items to manage expansion state internally
    _items = _copyItems(widget.items);
  }

  List<NoteTreeItem> _copyItems(List<NoteTreeItem> source) {
    return source.map((item) {
      return item.copyWith(
        children: item.children.isNotEmpty ? _copyItems(item.children) : [],
      );
    }).toList();
  }

  void _toggleExpand(NoteTreeItem item) {
    setState(() {
      // Find the corresponding item in our internal list
      _findAndUpdateItem(_items, item.id, (foundItem) {
        foundItem.isExpanded = !foundItem.isExpanded;
      });
    });
  }

  void _selectItem(NoteTreeItem item) {
    setState(() {
      _selectedItemId = item.id;
    });

    if (widget.onItemSelected != null) {
      widget.onItemSelected!(item);
    }
  }

  bool _findAndUpdateItem(
      List<NoteTreeItem> items, String id, Function(NoteTreeItem) update) {
    for (var i = 0; i < items.length; i++) {
      if (items[i].id == id) {
        update(items[i]);
        return true;
      }

      if (items[i].children.isNotEmpty) {
        if (_findAndUpdateItem(items[i].children, id, update)) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildTreeItems(_items),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTreeItems(List<NoteTreeItem> items) {
    List<Widget> widgets = [];

    for (var item in items) {
      widgets.add(_buildTreeItem(item));

      if (item.isFolder && item.isExpanded) {
        widgets.addAll(_buildTreeItems(item.children));
      }
    }

    return widgets;
  }

  Widget _buildTreeItem(NoteTreeItem item) {
    final isSelected = _selectedItemId == item.id;

    // Calculate indentation based on level
    const double baseIndent = 16.0;
    final double indentation = baseIndent * item.level;

    return InkWell(
      onTap: () {
        _selectItem(item);
      },
      child: Container(
        height: 24, // Keep items compact like Windows Explorer
        color:
            isSelected ? Theme.of(context).highlightColor : Colors.transparent,
        child: Row(
          children: [
            SizedBox(width: indentation),
            // Expand/Collapse button for folders
            if (item.isFolder)
              GestureDetector(
                onTap: () => _toggleExpand(item),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: Center(
                    child: Icon(
                      item.isExpanded ? Icons.remove : Icons.add,
                      size: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              )
            else
              SizedBox(width: 16),
            // Icon
            Icon(
              item.icon ??
                  (item.isFolder
                      ? (item.isExpanded ? Icons.folder_open : Icons.folder)
                      : Icons.description),
              size: 16,
              color: item.isFolder ? Colors.amber[700] : Colors.blue[700],
            ),
            const SizedBox(width: 4),
            // Item name
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that shows a classic tree view with connecting lines
class NoteTreeViewClassic extends StatefulWidget {
  final List<NoteTreeItem> items;
  final Function(NoteTreeItem)? onItemSelected;

  const NoteTreeViewClassic({
    Key? key,
    required this.items,
    this.onItemSelected,
  }) : super(key: key);

  @override
  State<NoteTreeViewClassic> createState() => _NoteTreeViewClassicState();
}

class _NoteTreeViewClassicState extends State<NoteTreeViewClassic> {
  String? _selectedItemId;

  // Deep copy the items to avoid modifying the original list
  late List<NoteTreeItem> _items;

  @override
  void initState() {
    super.initState();
    _initializeItems();
  }

  @override
  void didUpdateWidget(NoteTreeViewClassic oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _initializeItems();
    }
  }

  void _initializeItems() {
    // Create deep copies of items to manage expansion state internally
    _items = _copyItems(widget.items);
  }

  List<NoteTreeItem> _copyItems(List<NoteTreeItem> source) {
    return source.map((item) {
      return item.copyWith(
        children: item.children.isNotEmpty ? _copyItems(item.children) : [],
      );
    }).toList();
  }

  void _toggleExpand(NoteTreeItem item) {
    setState(() {
      // Find the corresponding item in our internal list
      _findAndUpdateItem(_items, item.id, (foundItem) {
        foundItem.isExpanded = !foundItem.isExpanded;
      });
    });
  }

  void _selectItem(NoteTreeItem item) {
    setState(() {
      _selectedItemId = item.id;
    });

    if (widget.onItemSelected != null) {
      widget.onItemSelected!(item);
    }
  }

  bool _findAndUpdateItem(
      List<NoteTreeItem> items, String id, Function(NoteTreeItem) update) {
    for (var i = 0; i < items.length; i++) {
      if (items[i].id == id) {
        update(items[i]);
        return true;
      }

      if (items[i].children.isNotEmpty) {
        if (_findAndUpdateItem(items[i].children, id, update)) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildTreeNodes(_items, isLast: []),
        ),
      ),
    );
  }

  List<Widget> _buildTreeNodes(List<NoteTreeItem> items,
      {required List<bool> isLast}) {
    List<Widget> widgets = [];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isLastItem = i == items.length - 1;

      // For the current item
      widgets.add(_buildTreeNode(
        item,
        isLastInLevel: isLastItem,
        isLast: [...isLast],
      ));

      // For children
      if (item.isFolder && item.isExpanded && item.children.isNotEmpty) {
        widgets.addAll(_buildTreeNodes(
          item.children,
          isLast: [...isLast, isLastItem],
        ));
      }
    }

    return widgets;
  }

  Widget _buildTreeNode(NoteTreeItem item,
      {required List<bool> isLast, required bool isLastInLevel}) {
    final isSelected = _selectedItemId == item.id;

    return InkWell(
      onTap: () => _selectItem(item),
      child: Container(
        height: 24, // Keep compact
        color:
            isSelected ? Theme.of(context).highlightColor : Colors.transparent,
        child: Row(
          children: [
            // Draw tree lines for each level
            ...List.generate(isLast.length, (index) {
              return SizedBox(
                width: 16,
                child: isLast[index]
                    ? Container() // No vertical line if it's the last item
                    : Center(
                        child: Container(
                          width: 1,
                          height: 24,
                          color: Colors.grey[400],
                        ),
                      ),
              );
            }),

            // The connection line to the current node
            SizedBox(
              width: 16,
              child: Center(
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 1,
                      color: Colors.grey[400],
                    ),
                    Expanded(
                      child: isLastInLevel
                          ? Container(
                              height: 12,
                              width: 1,
                              color: Colors.grey[400],
                            )
                          : Container(
                              height: 24,
                              width: 1,
                              color: Colors.grey[400],
                            ),
                    ),
                  ],
                ),
              ),
            ),

            // Expand/Collapse button for folders
            if (item.isFolder)
              GestureDetector(
                onTap: () => _toggleExpand(item),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      item.isExpanded ? Icons.remove : Icons.add,
                      size: 12.0,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              )
            else
              SizedBox(width: 16),

            const SizedBox(width: 4),

            // Icon
            Icon(
              item.icon ??
                  (item.isFolder
                      ? (item.isExpanded ? Icons.folder_open : Icons.folder)
                      : Icons.description),
              size: 16,
              color: item.isFolder ? Colors.amber[700] : Colors.blue[700],
            ),

            const SizedBox(width: 4),

            // Item name
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
