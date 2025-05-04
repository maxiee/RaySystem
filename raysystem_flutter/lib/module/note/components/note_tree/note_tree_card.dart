import 'package:flutter/material.dart';
import 'package:raysystem_flutter/card/card_manager.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/note_tree_view.dart';
import 'package:raysystem_flutter/module/note/components/note_tree/note_tree_card_controller.dart';
import '../../api/note_tree/note_tree_service.dart';

/// A card widget that displays a note tree explorer
class NoteTreeCard extends StatefulWidget {
  /// Optional tree service to use instead of the default mock service
  final NoteTreeService treeService;

  /// 卡片管理器，用于添加新卡片
  final CardManager? cardManager;

  const NoteTreeCard({
    super.key,
    required this.treeService,
    this.cardManager,
  });

  @override
  State<NoteTreeCard> createState() => _NoteTreeCardState();
}

class _NoteTreeCardState extends State<NoteTreeCard> {
  // Controller to handle all the business logic
  late NoteTreeCardController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller when the widget is created
    _controller = NoteTreeCardController(
      treeService: widget.treeService,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tree View
        Expanded(
          child: Stack(
            children: [
              NoteTreeViewClassic(
                key: _controller.treeViewKey, // Use the key from the controller
                treeService: _controller.treeService,
                autoLoadInitialData: true,
                onItemSelected: (item) {
                  setState(() {
                    _controller.handleItemSelected(item);
                  });
                },
                onAddChildNote: _controller.handleAddChildNote,
                onItemDoubleClicked: (item) => _controller
                    .handleItemDoubleClicked(item, widget.cardManager),
                onDeleteNote: _controller.handleDeleteNote,
                // Connect drag and drop event handlers
                onStartDrag: _controller.handleStartDrag,
                onEndDrag: _controller.handleEndDrag,
                canAcceptDrop: _controller.canAcceptDrop,
                onDropNote: _controller.handleDrop,
              ),

              // Show loading indicator during refresh
              if (_controller.isRefreshing)
                Container(
                  color: Colors.black12,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),

              Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Refresh'),
                        onPressed: _controller.isRefreshing
                            ? null
                            : () async {
                                setState(() {
                                  _controller.isRefreshing = true;
                                });
                                await _controller.fullRefresh();
                                setState(() {
                                  _controller.isRefreshing = false;
                                });
                              },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Actions bar
      ],
    );
  }
}
