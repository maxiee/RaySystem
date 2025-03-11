import 'package:flutter/material.dart';
import 'note_tree_model.dart';
import 'note_tree_view.dart';

/// A card widget that displays a note tree explorer
class NoteTreeCard extends StatefulWidget {
  final bool useClassicStyle;

  const NoteTreeCard({
    Key? key,
    this.useClassicStyle = true,
  }) : super(key: key);

  @override
  State<NoteTreeCard> createState() => _NoteTreeCardState();
}

class _NoteTreeCardState extends State<NoteTreeCard> {
  List<NoteTreeItem> _mockItems = [];
  NoteTreeItem? _selectedItem;

  @override
  void initState() {
    super.initState();
    _mockItems = MockNoteTreeData.generateMockData();
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
            child: widget.useClassicStyle
                ? NoteTreeViewClassic(
                    items: _mockItems,
                    onItemSelected: _handleItemSelected,
                  )
                : NoteTreeView(
                    items: _mockItems,
                    onItemSelected: _handleItemSelected,
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
                  onPressed: () {
                    setState(() {
                      _mockItems = MockNoteTreeData.generateMockData();
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
