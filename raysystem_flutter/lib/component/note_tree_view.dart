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
        child: Stack(
          children: [
            // Draw connecting lines
            Positioned.fill(
              child: Row(
                children: [
                  // Draw tree lines for each level
                  ...List.generate(isLast.length, (index) {
                    // Indentation for each level
                    return SizedBox(
                      width: 16,
                      child: isLast[index]
                          ? const SizedBox() // No vertical line if it's the last item
                          : CustomPaint(
                              size: const Size(16, 24),
                              painter: DashedLinePainter(
                                isVertical: true,
                                dashWidth: 1,
                                dashSpace: 2,
                                strokeWidth: 0.8,
                                color: Colors.grey[400]!,
                              ),
                            ),
                    );
                  }),

                  // Draw the branch line (horizontal + vertical)
                  SizedBox(
                    width: 16,
                    child: CustomPaint(
                      size: const Size(16, 24),
                      painter: BranchLinePainter(
                        isLastItem: isLastInLevel,
                        strokeWidth: 0.8,
                        color: Colors.grey[400]!,
                        isDashed: true,
                        dashWidth: 1,
                        dashSpace: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Draw content (folder/file icon and name)
            Row(
              children: [
                // Space for indentation levels
                SizedBox(width: 16.0 * isLast.length),

                // Space for the branch connection
                const SizedBox(width: 16),

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
                          width: 0.8,
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
                  CustomPaint(
                    size: const Size(16, 24),
                    painter: DashedLinePainter(
                      isVertical: false,
                      strokeWidth: 0.8,
                      color: Colors.grey[400]!,
                      dashWidth: 1,
                      dashSpace: 2,
                    ),
                  ),

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
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter to draw dashed lines
class DashedLinePainter extends CustomPainter {
  final bool isVertical;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final Color color;

  DashedLinePainter({
    required this.isVertical,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double start = 0;
    final totalLength = isVertical ? size.height : size.width;
    final dashLength = dashWidth + dashSpace;

    while (start < totalLength) {
      // Draw a small dash
      double end = start + dashWidth;
      if (end > totalLength) end = totalLength;

      if (isVertical) {
        canvas.drawLine(
            Offset(size.width / 2, start), Offset(size.width / 2, end), paint);
      } else {
        canvas.drawLine(Offset(start, size.height / 2),
            Offset(end, size.height / 2), paint);
      }

      start = start + dashLength;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for the branch lines (L-shaped connection)
class BranchLinePainter extends CustomPainter {
  final bool isLastItem;
  final double strokeWidth;
  final Color color;
  final bool isDashed;
  final double dashWidth;
  final double dashSpace;

  BranchLinePainter({
    required this.isLastItem,
    required this.strokeWidth,
    required this.color,
    this.isDashed = true,
    this.dashWidth = 1,
    this.dashSpace = 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw horizontal line from middle to right
    if (isDashed) {
      // Draw dashed horizontal line
      double startX = size.width / 2; // Start from middle
      double endX = size.width; // Go all the way to the right
      double y = size.height / 2;

      double current = startX;
      while (current < endX) {
        double dashEnd = current + dashWidth;
        if (dashEnd > endX) dashEnd = endX;

        canvas.drawLine(
          Offset(current, y),
          Offset(dashEnd, y),
          paint,
        );

        current = current + dashWidth + dashSpace;
      }
    } else {
      // Solid line from middle to right
      canvas.drawLine(
        Offset(size.width / 2, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );
    }

    // Vertical line
    if (isLastItem) {
      // Draw only half-height vertical line if it's the last item
      if (isDashed) {
        // Draw dashed vertical line
        double startY = 0;
        double endY = size.height / 2;
        double x = size.width / 2;

        double current = startY;
        while (current < endY) {
          double dashEnd = current + dashWidth;
          if (dashEnd > endY) dashEnd = endY;

          canvas.drawLine(
            Offset(x, current),
            Offset(x, dashEnd),
            paint,
          );

          current = current + dashWidth + dashSpace;
        }
      } else {
        // Solid vertical line
        canvas.drawLine(
          Offset(size.width / 2, 0),
          Offset(size.width / 2, size.height / 2),
          paint,
        );
      }
    } else {
      // Draw full-height vertical line
      if (isDashed) {
        // Draw dashed vertical line
        double startY = 0;
        double endY = size.height;
        double x = size.width / 2;

        double current = startY;
        while (current < endY) {
          double dashEnd = current + dashWidth;
          if (dashEnd > endY) dashEnd = endY;

          canvas.drawLine(
            Offset(x, current),
            Offset(x, dashEnd),
            paint,
          );

          current = current + dashWidth + dashSpace;
        }
      } else {
        // Solid vertical line
        canvas.drawLine(
          Offset(size.width / 2, 0),
          Offset(size.width / 2, size.height),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
