import 'package:flutter/material.dart';
import 'package:raysystem_flutter/module/note/components/note_tree_view.dart';
import 'package:raysystem_flutter/module/note/components/note_tree_model.dart';
import 'note_tree_service.dart';
import 'mock_note_tree_service.dart';

/// A card widget that displays a note tree explorer
class NoteTreeCard extends StatefulWidget {
  /// Optional tree service to use instead of the default mock service
  final NoteTreeService? treeService;

  const NoteTreeCard({
    Key? key,
    this.treeService,
  }) : super(key: key);

  @override
  State<NoteTreeCard> createState() => _NoteTreeCardState();
}

class _NoteTreeCardState extends State<NoteTreeCard> {
  NoteTreeItem? _selectedItem;

  // Create a service instance - using provided one or creating a mock
  late final NoteTreeService _noteTreeService;

  // We no longer need to preload the items, we'll let the tree view handle it
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _noteTreeService = widget.treeService ?? MockNoteTreeService();
  }

  void _handleItemSelected(NoteTreeItem item) {
    setState(() {
      _selectedItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 3.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.folder,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Notes Explorer',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (_selectedItem != null)
                  Text(
                    'Selected: ${_selectedItem!.name}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),

          // Tree View
          Expanded(
            child: Stack(
              children: [
                NoteTreeViewClassic(
                  // Pass the abstract service to the tree view
                  treeService: _noteTreeService,
                  autoLoadInitialData: true,
                  onItemSelected: _handleItemSelected,
                ),

                // Show an overlay loading indicator during refresh
                if (_isRefreshing)
                  Container(
                    color: Colors.black12,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),

          // Actions bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Refresh'),
                  onPressed: _isRefreshing
                      ? null
                      : () {
                          setState(() {
                            _isRefreshing = true;

                            // Reset the service cache
                            _noteTreeService.resetCache();

                            // We need to rebuild to create a new tree view with empty initial items
                            Future.delayed(const Duration(milliseconds: 300),
                                () {
                              setState(() {
                                _isRefreshing = false;
                              });
                            });
                          });
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
