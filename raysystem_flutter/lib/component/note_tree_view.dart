import 'package:flutter/material.dart';
import '../module/note/components/note_tree_model.dart';
import '../module/note/components/mock_note_tree_service.dart';

/// A widget that shows a classic tree view with connecting lines
class NoteTreeViewClassic extends StatefulWidget {
  /// Initial items to show in the tree (typically root level items)
  final List<NoteTreeItem>? initialItems;

  /// Callback when an item is selected
  final Function(NoteTreeItem)? onItemSelected;

  /// Flag to determine if the widget should load initial data itself
  final bool autoLoadInitialData;

  /// Service to load tree data (optional, will create one if not provided)
  final MockNoteTreeService? treeService;

  const NoteTreeViewClassic({
    Key? key,
    this.initialItems,
    this.onItemSelected,
    this.autoLoadInitialData = true,
    this.treeService,
  }) : super(key: key);

  @override
  State<NoteTreeViewClassic> createState() => _NoteTreeViewClassicState();
}

class _NoteTreeViewClassicState extends State<NoteTreeViewClassic> {
  String? _selectedItemId;

  /// Items in the tree
  late List<NoteTreeItem> _items;

  /// Mock service for data loading (would be replaced with real API service)
  late final MockNoteTreeService _treeService;

  /// Tracks which folders are currently loading their children
  final Set<String> _loadingFolders = {};

  /// Loading state for initial data
  bool _isInitialLoading = false;

  /// Cache to track which folders have children (to show expand button)
  final Map<String, bool> _hasChildrenCache = {};

  @override
  void initState() {
    super.initState();
    _treeService = widget.treeService ?? MockNoteTreeService();
    _items = widget.initialItems ?? [];

    if (widget.autoLoadInitialData && _items.isEmpty) {
      _loadInitialData();
    }
  }

  @override
  void didUpdateWidget(NoteTreeViewClassic oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialItems != oldWidget.initialItems &&
        widget.initialItems != null) {
      setState(() {
        _items = widget.initialItems!;
      });
    }
  }

  /// Load initial/root data
  Future<void> _loadInitialData() async {
    setState(() {
      _isInitialLoading = true;
    });

    try {
      final initialItems = await _treeService.getInitialItems();

      // For each folder, assume it has children based on isFolder property
      for (var item in initialItems.where((item) => item.isFolder)) {
        _hasChildrenCache[item.id] = true;
      }

      setState(() {
        _items = initialItems;
        _isInitialLoading = false;
      });
    } catch (e) {
      setState(() {
        _isInitialLoading = false;
      });
      // In a real app, you would show an error message
      debugPrint('Error loading initial data: $e');
    }
  }

  /// Load children for a specific folder
  Future<void> _loadChildren(NoteTreeItem folder) async {
    if (_loadingFolders.contains(folder.id)) {
      return; // Already loading
    }

    setState(() {
      _loadingFolders.add(folder.id);
    });

    try {
      final children = await _treeService.getChildrenFor(folder.id);

      // For each folder in the children, assume it has children
      for (var item in children.where((item) => item.isFolder)) {
        _hasChildrenCache[item.id] = true;
      }

      setState(() {
        // 在当前根级别项目列表中查找该文件夹的索引位置
        // Find item index in the current items list
        int folderIndex = -1;
        for (int i = 0; i < _items.length; i++) {
          if (_items[i].id == folder.id) {
            folderIndex = i;
            break;
          }
        }

        // 如果文件夹直接位于根级别(即_items数组中)
        // If found directly in the root level
        if (folderIndex != -1) {
          // 使用copyWith方法创建一个新对象，设置isExpanded为true并添加children
          // Update with new version that has the children
          _items[folderIndex] = _items[folderIndex].copyWith(
            isExpanded: true,
            children: children,
          );
        } else {
          // 如果文件夹不在根级别，则在整个树中查找并更新它
          // Otherwise update it wherever it is in the tree
          _findAndUpdateItem(_items, folder.id, (foundItem) {
            // 直接更新原始引用的字段
            foundItem.isExpanded = true;
            // 重要：直接替换children数组
            foundItem.children.clear();
            foundItem.children.addAll(children);

            // For debugging
            debugPrint(
                '📂 Updated folder ${folder.id} with ${children.length} children');
          });
        }
        // 完成加载，从加载中文件夹集合中移除此ID
        _loadingFolders.remove(folder.id);
      });
    } catch (e) {
      setState(() {
        // 如果加载失败，仍然从加载中文件夹集合中移除此ID
        _loadingFolders.remove(folder.id);
      });
      // In a real app, you would show an error message
      debugPrint('Error loading children for ${folder.id}: $e');
    }
  }

  void _toggleExpand(NoteTreeItem item) {
    if (!item.isFolder) return;

    // If folder is already expanded, just collapse it
    if (item.isExpanded) {
      setState(() {
        _findAndUpdateItem(_items, item.id, (foundItem) {
          foundItem.isExpanded = false;
        });
      });
      return;
    }

    // If children are already loaded, just expand
    if (item.children.isNotEmpty) {
      setState(() {
        _findAndUpdateItem(_items, item.id, (foundItem) {
          foundItem.isExpanded = true;
        });
      });
      return;
    }

    // Otherwise, load children first
    _loadChildren(item);
  }

  void _selectItem(NoteTreeItem item) {
    setState(() {
      _selectedItemId = item.id;
    });

    if (widget.onItemSelected != null) {
      widget.onItemSelected!(item);
    }
  }

  /// 在树结构中查找指定ID的节点并对其应用更新操作
  ///
  /// [items] 要搜索的节点列表
  /// [id] 要查找的节点ID
  /// [update] 找到节点后要应用的更新函数
  ///
  /// 返回一个布尔值，表示是否找到并更新了节点
  bool _findAndUpdateItem(
      List<NoteTreeItem> items, String id, Function(NoteTreeItem) update) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == id) {
        // 找到匹配ID的节点，应用更新函数
        update(items[i]);
        return true;
      }

      // 递归搜索子节点
      if (items[i].children.isNotEmpty) {
        if (_findAndUpdateItem(items[i].children, id, update)) {
          return true;
        }
      }
    }
    // 在整个树中未找到指定ID的节点
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
    final isLoading = _loadingFolders.contains(item.id);
    final hasChildren = item.isFolder && (_hasChildrenCache[item.id] ?? false);

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

                // Expand/Collapse button for folders or loading indicator
                if (item.isFolder)
                  GestureDetector(
                    onTap: isLoading ? null : () => _toggleExpand(item),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: hasChildren || isLoading
                              ? Colors.grey[400]!
                              : Colors.transparent,
                          width: 0.8,
                        ),
                      ),
                      child: Center(
                        child: isLoading
                            ? SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: Colors.grey[600],
                                ),
                              )
                            : hasChildren
                                ? Icon(
                                    item.isExpanded ? Icons.remove : Icons.add,
                                    size: 12.0,
                                    color: Colors.grey[800],
                                  )
                                : const SizedBox(), // Empty if no children
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
