import 'package:flutter/material.dart';
import 'note_tree_model.dart';
import 'note_tree_view.dart';
import 'mock_note_tree_service.dart';

/// A card widget that displays a note tree explorer
class NoteTreeCard extends StatefulWidget {
  const NoteTreeCard({
    Key? key,
  }) : super(key: key);

  @override
  State<NoteTreeCard> createState() => _NoteTreeCardState();
}

class _NoteTreeCardState extends State<NoteTreeCard> {
  NoteTreeItem? _selectedItem;

  // Create a shared instance of the mock service
  final _noteTreeService = MockNoteTreeService();

  // We no longer need to preload the items, we'll let the tree view handle it
  bool _isRefreshing = false;

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
                  // Use the mock service for lazy-loading
                  treeService: _noteTreeService,
                  autoLoadInitialData:
                      true, // Let the tree view load initial data
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

                            // Create a new tree service to force a fresh load
                            // In a real app, this would just clear caches or reload from API
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
