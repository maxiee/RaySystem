import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/new/base/note_tree_provider.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/notifier/tree_state.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/painters.dart';
import '../../model/note_tree_model.dart';

/// A widget that shows a classic tree view with connecting lines
class NoteTreeViewClassic extends ConsumerWidget {
  /// The ID of the currently selected item, or null if none is selected.
  final int? selectedItemId;

  /// A set of IDs for folders that are currently expanded.
  final Set<int> expandedFolderIds;

  /// A set of IDs for folders that are currently loading children.
  final Set<int> loadingFolderIds;

  /// The ID of the item currently being dragged, or null.
  final int? draggedItemId;

  /// Indicates if a drag operation is currently in progress.
  final bool isDragging;

  /// The ID of the potential drop target currently being hovered over, or null.
  final int? hoveredTargetId;

  /// Indicates if the currently hovered drop target is valid.
  final bool isHoverTargetValid;

  /// Callback when an item is selected.
  final Function(NoteTreeItem) onItemSelected;

  /// Callback to toggle the expansion state of a folder.
  final Function(NoteTreeItem) onToggleExpand;

  /// Callback when add child note is requested via context menu.
  final Function(NoteTreeItem) onAddChildNote;

  /// Callback when a note is double-clicked.
  final Function(NoteTreeItem) onItemDoubleClicked;

  /// Callback when delete note is requested via context menu.
  final Function(NoteTreeItem) onDeleteNote;

  /// Callback when a note starts being dragged.
  final Function(NoteTreeItem) onStartDrag;

  /// Callback when drag ends (successfully dropped or cancelled).
  final Function() onEndDrag;

  /// Callback to signal the start of hover over a potential drop target.
  /// The state manager should perform validation and update `hoveredTargetId` and `isHoverTargetValid`.
  final Function(NoteTreeItem targetItem) onHoverTarget;

  /// Callback to signal that the drag has left a potential target or the drop occurred.
  /// The state manager should clear the hover state.
  final Function() onLeaveTarget;

  /// Callback when a dragged item is dropped onto a target item.
  /// Assumes validation has already occurred based on hover state.
  final Function(NoteTreeItem targetItem) onDropNote;

  const NoteTreeViewClassic({
    Key? key,
    this.selectedItemId,
    required this.expandedFolderIds,
    required this.loadingFolderIds,
    this.draggedItemId,
    required this.isDragging,
    this.hoveredTargetId,
    required this.isHoverTargetValid,
    required this.onItemSelected,
    required this.onToggleExpand,
    required this.onAddChildNote,
    required this.onItemDoubleClicked,
    required this.onDeleteNote,
    required this.onStartDrag,
    required this.onEndDrag,
    required this.onHoverTarget,
    required this.onLeaveTarget,
    required this.onDropNote,
    // Removed: initialItems, autoLoadInitialData, treeService, canAcceptDrop
  }) : super(key: key);

  // --- Context Menu ---
  /// Show context menu for an item
  void _showContextMenu(
      BuildContext context, NoteTreeItem item, Offset position) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

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
      if (value == 'add_child') {
        onAddChildNote(item);
      } else if (value == 'delete_note') {
        onDeleteNote(item);
      }
    });
  }

  // --- Build Methods ---
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(noteTreeProvider);
    final notifier = ref.read(noteTreeProvider.notifier);

    // Added WidgetRef
    // Removed _isInitialLoading check, parent handles loading state
    return Container(
      // Removed Expanded, parent should handle layout
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        // Removed inner Expanded, Column takes needed space
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              _buildTreeNodes(context, notifier.getRootItems(), isLast: []),
        ),
      ),
    );
  }

  List<Widget> _buildNodes(
      BuildContext context, List<NoteTreeItem> items) {
    return items.map((item) => _)
  }

  /// Recursively builds the list of Widgets for the tree nodes.
  List<Widget> _buildTreeNodes(
      BuildContext context, List<NoteTreeItem> currentLevelItems,
      {required List<bool> isLast}) {
    List<Widget> widgets = [];

    for (int i = 0; i < currentLevelItems.length; i++) {
      final item = currentLevelItems[i];
      final isLastItem = i == currentLevelItems.length - 1;

      // Build the node for the current item
      widgets.add(_buildTreeNode(
        context,
        item,
        isLastInLevel: isLastItem,
        isLast: [...isLast], // Pass copies of the list
      ));

      // If the item is an expanded folder, recursively build its children
      if (item.isFolder &&
          expandedFolderIds.contains(item.id) &&
          item.children.isNotEmpty) {
        widgets.addAll(_buildTreeNodes(
          context,
          item.children,
          isLast: [...isLast, isLastItem], // Pass copies of the list
        ));
      }
    }

    return widgets;
  }

  /// Builds the UI for a single tree node, including lines, icon, text, and drag/drop wrappers.
  Widget _buildTreeNode(BuildContext context, NoteTreeState state, NoteTreeItem item,
      {required List<bool> isLast, required bool isLastInLevel}) {
    // Determine state based on passed props
    final bool isSelected = state.selectedItem?.id == item.id;
    final bool isLoading = loadingFolderIds.contains(item.id);
    // A folder *can* be expanded if it's marked as a folder.
    // The actual icon (+/-) depends on whether it *is* expanded (in expandedFolderIds).
    final bool canExpand = item.isFolder;
    final bool isExpanded = expandedFolderIds.contains(item.id);

    // Determine drag target state based on props
    final bool isCurrentDragTarget = hoveredTargetId == item.id;

    // Wrap the node with Draggable and DragTarget
    return _buildDragAndDropWrapper(
      context,
      item: item,
      isLastInLevel: isLastInLevel,
      isLast: isLast,
      isSelected: isSelected,
      isLoading: isLoading,
      canExpand: canExpand,
      isExpanded: isExpanded,
      isCurrentDragTarget: isCurrentDragTarget,
    );
  }

  /// Builds the Draggable and DragTarget wrappers around the node content.
  Widget _buildDragAndDropWrapper(
    BuildContext context, {
    required NoteTreeItem item,
    required List<bool> isLast,
    required bool isLastInLevel,
    required bool isSelected,
    required bool isLoading,
    required bool canExpand, // Renamed from hasChildren for clarity
    required bool isExpanded,
    required bool isCurrentDragTarget,
  }) {
    // Build the visual content of the node first
    final Widget treeNodeContent = _buildNodeContent(
      context,
      item: item,
      isLast: isLast,
      isLastInLevel: isLastInLevel,
      isSelected: isSelected,
      isLoading: isLoading,
      canExpand: canExpand,
      isExpanded: isExpanded,
    );

    // Wrap with DragTarget to handle drops
    return DragTarget<NoteTreeItem>(
      onWillAccept: (data) {
        // Always return true immediately to allow hover effect.
        // Signal the state manager to start async validation.
        if (data != null) {
          // Prevent immediate self-drop visual glitch if needed, though validation handles logic
          if (data.id == item.id) return false;
          onHoverTarget(item); // Notify state manager to validate this target
        }
        return true; // Allow hover while validation runs
      },
      onAccept: (data) {
        // Only call drop handler if the target was marked as valid during hover
        if (isHoverTargetValid && hoveredTargetId == item.id) {
          debugPrint(
              '🎯 [View] onAccept: Dropping ${data.name} onto valid target ${item.name}');
          onDropNote(item);
        } else {
          debugPrint(
              '🎯 [View] onAccept: Drop rejected on ${item.name} (invalid or not hovered)');
        }
        onLeaveTarget(); // Clear hover state after drop attempt
      },
      onLeave: (data) {
        // Signal the state manager to clear hover state
        onLeaveTarget();
      },
      builder: (context, candidateData, rejectedData) {
        // Determine visual feedback based on state managed externally
        final bool showDropFeedback =
            isCurrentDragTarget && candidateData.isNotEmpty;
        final bool isValidDropTarget = showDropFeedback && isHoverTargetValid;

        return Container(
          decoration: BoxDecoration(
            border: showDropFeedback
                ? Border.all(
                    color: isValidDropTarget
                        ? Theme.of(context)
                            .colorScheme
                            .primary // Valid target color
                        : Colors.red, // Invalid target color
                    width: 1.5,
                  )
                : null,
            borderRadius: showDropFeedback ? BorderRadius.circular(4) : null,
            color: showDropFeedback
                ? (isValidDropTarget
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.1) // Valid target background
                        : Colors.red
                            .withOpacity(0.1) // Invalid target background
                    )
                : Colors.transparent,
          ),
          // Wrap with Draggable
          child: Draggable<NoteTreeItem>(
            data: item,
            feedback: _buildDragFeedback(
                context, item), // Use helper for feedback widget
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: treeNodeContent,
            ),
            onDragStarted: () {
              onStartDrag(item); // Notify state manager
            },
            onDragEnd: (details) {
              // onEndDrag is called regardless of whether it was accepted or cancelled
              onEndDrag(); // Notify state manager
            },
            // onDraggableCanceled is deprecated, use onDragEnd
            maxSimultaneousDrags: 1,
            child: treeNodeContent, // The actual node content
          ),
        );
      },
    );
  }

  /// Builds the widget shown while dragging.
  Widget _buildDragFeedback(BuildContext context, NoteTreeItem item) {
    return Material(
      elevation: 6.0,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12.0, vertical: 4.0), // Adjusted padding
        // Constrain width to avoid excessive feedback size
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .cardColor
              .withOpacity(0.9), // Slightly transparent
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // Prevent row from expanding unnecessarily
          children: [
            Icon(
              item.icon ?? (item.isFolder ? Icons.folder : Icons.description),
              size: 16, // Match node icon size
              color: item.isFolder ? Colors.amber[700] : Colors.blue[700],
            ),
            const SizedBox(width: 8),
            // Flexible helps handle long names within constrained width
            Flexible(
              child: Text(
                item.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium, // Use theme text style
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the actual content (lines, icons, text) of a tree node.
  Widget _buildNodeContent(
    BuildContext context, {
    required NoteTreeItem item,
    required List<bool> isLast, // List of booleans indicating if ancestors are last in their level
    required bool isLastInLevel, // If this item is the last in its level
    required bool isSelected,
    required bool isLoading,
    required bool canExpand, // If it's a folder type
    required bool isExpanded, // If it's currently expanded
  }) {
    return GestureDetector(
      onSecondaryTapDown: (details) {
        _showContextMenu(context, item, details.globalPosition);
      },
      child: InkWell(
        onTap: () => onItemSelected(item),
        onDoubleTap: () => onItemDoubleClicked(item),
        // Apply visual feedback for selection
        child: Container(
          height: 24, // Consistent node height
          color: isSelected
              ? Theme.of(context).highlightColor
              : Colors.transparent,
          padding: const EdgeInsets.only(
              right: 8.0), // Add some padding to the right
          child: Stack(
            children: [
              // --- Connecting Lines ---
              Positioned.fill(
                child: Row(
                  children: [
                    // Indentation lines based on depth and whether ancestors were last items
                    ...List.generate(isLast.length, (index) {
                      return SizedBox(
                        width: 16,
                        child: isLast[index]
                            ? const SizedBox() // No vertical line if ancestor was last
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
                    // Branch line connecting to the node content
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
              // --- Node Content (Icon, Text) ---
              Row(
                children: [
                  // Indentation space matching the lines
                  SizedBox(width: 16.0 * isLast.length),
                  // Branch line space
                  const SizedBox(width: 16),
                  // Expand/Collapse button or loading indicator
                  if (canExpand) // Only show for folders
                    GestureDetector(
                      onTap: isLoading ? null : () => onToggleExpand(item),
                      child: Container(
                        width: 16, height: 16,
                        // Add border only if it can be expanded or is loading
                        decoration: (canExpand || isLoading)
                            ? BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey[400]!, width: 0.8),
                              )
                            : null,
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  // Loading indicator
                                  width: 10, height: 10,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 1.5, color: Colors.grey),
                                )
                              : Icon(
                                  // Expand/collapse icon
                                  isExpanded ? Icons.remove : Icons.add,
                                  size: 12.0, color: Colors.grey[800],
                                ),
                        ),
                      ),
                    )
                  else // Non-folders get a horizontal line segment instead of button
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
                  // Node Icon
                  Icon(
                    item.icon ??
                        (canExpand
                            ? (isExpanded ? Icons.folder_open : Icons.folder)
                            : Icons.description),
                    size: 16,
                    color: canExpand ? Colors.amber[700] : Colors.blue[700],
                  ),
                  const SizedBox(width: 4),
                  // Node Name
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
      ),
    );
  }
}
