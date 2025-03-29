import 'package:flutter/material.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/painters.dart';
import '../../model/note_tree_model.dart';
import '../../api/note_tree/note_tree_service.dart';

/// A widget that shows a classic tree view with connecting lines
class NoteTreeViewClassic extends StatefulWidget {
  /// Initial items to show in the tree (typically root level items)
  final List<NoteTreeItem>? initialItems;

  /// Callback when an item is selected
  final Function(NoteTreeItem)? onItemSelected;

  /// Callback when add child note is requested
  final Function(NoteTreeItem)? onAddChildNote;
  
  /// Callback when a note is double-clicked
  final Function(NoteTreeItem)? onItemDoubleClicked;
  
  /// Callback when delete note is requested
  final Function(NoteTreeItem)? onDeleteNote;

  /// Flag to determine if the widget should load initial data itself
  final bool autoLoadInitialData;

  /// Service to load tree data (optional, will create a mock one if not provided)
  final NoteTreeService treeService;

  const NoteTreeViewClassic({
    Key? key,
    this.initialItems,
    this.onItemSelected,
    this.onAddChildNote,
    this.onItemDoubleClicked,
    this.onDeleteNote,
    this.autoLoadInitialData = true,
    required this.treeService,
  }) : super(key: key);

  @override
  State<NoteTreeViewClassic> createState() => NoteTreeViewClassicState();
}

class NoteTreeViewClassicState extends State<NoteTreeViewClassic> {
  int? _selectedItemId;

  /// Items in the tree
  late List<NoteTreeItem> _items;

  /// Service for data loading
  late final NoteTreeService _treeService;

  /// Tracks which folders are currently loading their children
  final Set<int> _loadingFolders = {};

  /// Loading state for initial data
  bool _isInitialLoading = false;

  /// Cache to track which folders have children (to show expand button)
  final Map<int, bool> _hasChildrenCache = {};

  @override
  void initState() {
    super.initState();
    _treeService = widget.treeService;
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
    if (!mounted) return;
    setState(() {
      _isInitialLoading = true;
    });

    try {
      final initialItems = await _treeService.getInitialItems();

      // For each folder, assume it has children based on isFolder property
      for (var item in initialItems.where((item) => item.isFolder)) {
        _hasChildrenCache[item.id] = true;
      }

      if (!mounted) return;
      setState(() {
        _items = initialItems;
        _isInitialLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitialLoading = false;
      });
      // In a real app, you would show an error message
      debugPrint('Error loading initial data: $e');
    }
  }
  
  /// Public method to load initial data that can be called by parent widget
  Future<void> loadInitialData() async {
    await _loadInitialData();
  }

  /// Load children for a specific folder
  Future<void> _loadChildren(NoteTreeItem folder) async {
    if (_loadingFolders.contains(folder.id) || !mounted) {
      return; // Already loading or widget unmounted
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

      if (!mounted) return;
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
      if (!mounted) return;
      setState(() {
        // 如果加载失败，仍然从加载中文件夹集合中移除此ID
        _loadingFolders.remove(folder.id);
      });
      // In a real app, you would show an error message
      debugPrint('Error loading children for ${folder.id}: $e');
    }
  }

  /// Refresh children for a specific note, ensuring it's loaded and expanded
  Future<void> refreshChildren(int noteId) async {
    // Find the note item
    NoteTreeItem? item;
    bool found = _findAndUpdateItem(_items, noteId, (foundItem) {
      item = foundItem;
    });

    if (!found || item == null || !mounted) return;

    setState(() {
      _loadingFolders.add(noteId);
      // Ensure the item is marked as a folder and can be expanded
      if (!item!.isFolder) {
        _findAndUpdateItem(_items, noteId, (foundItem) {
          foundItem.isFolder = true;
        });
      }
      _hasChildrenCache[noteId] = true;
    });

    try {
      // Force the service to fetch fresh data by passing a cache buster parameter
      final children = await _treeService.getChildrenFor(noteId);
      
      if (!mounted) return;
      setState(() {
        _findAndUpdateItem(_items, noteId, (foundItem) {
          foundItem.isExpanded = true;
          // Important: Replace the entire children array
          foundItem.children.clear();
          foundItem.children.addAll(children);
          
          // Update the hasChildren cache based on the latest data
          _hasChildrenCache[noteId] = children.isNotEmpty;
          
          // For debugging
          debugPrint('🔄 Refreshed folder $noteId with ${children.length} children');
        });
        _loadingFolders.remove(noteId);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingFolders.remove(noteId);
      });
      debugPrint('Error refreshing children for $noteId: $e');
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
  
  // 处理双击事件
  void _handleDoubleClick(NoteTreeItem item) {
    if (widget.onItemDoubleClicked != null) {
      widget.onItemDoubleClicked!(item);
    }
  }

  /// Show context menu for an item
  void _showContextMenu(BuildContext context, NoteTreeItem item, Offset position) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        position & const Size(1, 1),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          value: 'add_child',
          child: Row(
            children: const [
              Icon(Icons.add, size: 16),
              SizedBox(width: 8),
              Text('Add Child Note'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete_note',
          child: Row(
            children: const [
              Icon(Icons.delete, size: 16, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete Note', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'add_child' && widget.onAddChildNote != null) {
        widget.onAddChildNote!(item);
      } else if (value == 'delete_note' && widget.onDeleteNote != null) {
        widget.onDeleteNote!(item);
      }
    });
  }

  /// 在树结构中查找指定ID的节点并对其应用更新操作
  ///
  /// [items] 要搜索的节点列表
  /// [id] 要查找的节点ID
  /// [update] 找到节点后要应用的更新函数
  ///
  /// 返回一个布尔值，表示是否找到并更新了节点
  bool _findAndUpdateItem(
      List<NoteTreeItem> items, int id, Function(NoteTreeItem) update) {
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

  /// 找到一个笔记节点的父节点ID
  /// 如果是根级别笔记，返回0
  /// 如果找不到父节点，返回null
  Future<int?> findParentId(int noteId) async {
    // 首先检查是否为根级别笔记
    bool isRootNote = false;
    for (var rootItem in _items) {
      if (rootItem.id == noteId) {
        isRootNote = true;
        break;
      }
    }
    
    if (isRootNote) {
      return 0; // 根级别笔记返回0
    }
    
    // 否则在树结构中搜索父节点
    for (var rootItem in _items) {
      int? parentId = _findParentIdInSubtree(rootItem, noteId);
      if (parentId != null) {
        return parentId;
      }
    }
    
    // 如果在树中找不到，返回null
    return null;
  }

  /// 在子树中递归查找节点的父ID
  int? _findParentIdInSubtree(NoteTreeItem parent, int childId) {
    // 检查直接子节点
    for (var child in parent.children) {
      if (child.id == childId) {
        return parent.id;
      }
      
      // 递归检查孙子节点
      int? foundId = _findParentIdInSubtree(child, childId);
      if (foundId != null) {
        return foundId;
      }
    }
    
    return null;
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

  /// 构建单个树节点的UI
  /// [item] 当前要构建的树节点项目
  /// [isLast] 记录从根节点到当前节点路径上，每一级是否为该级的最后一个节点
  /// [isLastInLevel] 当前节点是否为其所在层级的最后一个节点
  Widget _buildTreeNode(NoteTreeItem item,
      {required List<bool> isLast, required bool isLastInLevel}) {
    // 判断当前节点是否被选中
    final isSelected = _selectedItemId == item.id;
    // 判断当前节点是否正在加载子节点
    final isLoading = _loadingFolders.contains(item.id);
    // 判断当前节点是否有子节点（用于显示展开/折叠按钮）
    final hasChildren = item.isFolder && (_hasChildrenCache[item.id] ?? false);

    return GestureDetector(
      // Handle right-click for context menu
      onSecondaryTapDown: (details) {
        _showContextMenu(context, item, details.globalPosition);
      },
      child: InkWell(
        // 点击整个节点区域时触发选中事件
        onTap: () => _selectItem(item),
        // 双击节点时触发双击事件
        onDoubleTap: () => _handleDoubleClick(item),
        child: Container(
          height: 24, // 设置节点高度保持紧凑布局
          // 选中状态时使用高亮背景色，否则透明
          color:
              isSelected ? Theme.of(context).highlightColor : Colors.transparent,
          child: Stack(
            children: [
              // 绘制连接线部分
              Positioned.fill(
                child: Row(
                  children: [
                    // 为每一级层级绘制对应的连接线
                    ...List.generate(isLast.length, (index) {
                      // 每一级层级的缩进宽度
                      return SizedBox(
                        width: 16,
                        child: isLast[index]
                            ? const SizedBox() // 如果是该级的最后一项，则不需要绘制垂直连接线
                            : CustomPaint(
                                size: const Size(16, 24),
                                painter: DashedLinePainter(
                                  isVertical: true, // 垂直虚线
                                  dashWidth: 1, // 虚线段宽度
                                  dashSpace: 2, // 虚线间隔
                                  strokeWidth: 0.8, // 线条粗细
                                  color: Colors.grey[400]!, // 线条颜色
                                ),
                              ),
                      );
                    }),

                    // 绘制分支连接线（水平+垂直组合）
                    SizedBox(
                      width: 16,
                      child: CustomPaint(
                        size: const Size(16, 24),
                        painter: BranchLinePainter(
                          isLastItem: isLastInLevel, // 是否为最后一项，决定了连接线的形状
                          strokeWidth: 0.8, // 线条粗细
                          color: Colors.grey[400]!, // 线条颜色
                          isDashed: true, // 使用虚线样式
                          dashWidth: 1, // 虚线段宽度
                          dashSpace: 2, // 虚线间隔
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 绘制节点内容部分（文件夹/文件图标和名称）
              Row(
                children: [
                  // 根据层级缩进的空间
                  SizedBox(width: 16.0 * isLast.length),

                  // 分支连接线的空间
                  const SizedBox(width: 16),

                  // 文件夹的展开/折叠按钮或加载指示器
                  if (item.isFolder)
                    GestureDetector(
                      // 点击展开/折叠按钮时触发对应事件，如果正在加载则禁用点击
                      onTap: isLoading ? null : () => _toggleExpand(item),
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          // 如果有子节点或正在加载，则显示边框
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
                                  // 加载中显示旋转进度指示器
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: Colors.grey[600],
                                  ),
                                )
                              : hasChildren
                                  ? Icon(
                                      // 根据展开状态显示加号或减号图标
                                      item.isExpanded ? Icons.remove : Icons.add,
                                      size: 12.0,
                                      color: Colors.grey[800],
                                    )
                                  : const SizedBox(), // 没有子节点时显示空白
                        ),
                      ),
                    )
                  else
                    // 非文件夹项目显示水平虚线
                    CustomPaint(
                      size: const Size(16, 24),
                      painter: DashedLinePainter(
                        isVertical: false, // 水平虚线
                        strokeWidth: 0.8,
                        color: Colors.grey[400]!,
                        dashWidth: 1,
                        dashSpace: 2,
                      ),
                    ),

                  const SizedBox(width: 4),

                  // 节点图标
                  Icon(
                    // 使用节点提供的图标，或根据节点类型选择默认图标
                    item.icon ??
                        (item.isFolder
                            ? (item.isExpanded ? Icons.folder_open : Icons.folder)
                            : Icons.description),
                    size: 16,
                    color: item.isFolder
                        ? Colors.amber[700]
                        : Colors.blue[700], // 文件夹和文件使用不同颜色
                  ),

                  const SizedBox(width: 4),

                  // 节点名称文本
                  Expanded(
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 13,
                        // 选中状态使用粗体显示
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis, // 文本过长时显示省略号
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
