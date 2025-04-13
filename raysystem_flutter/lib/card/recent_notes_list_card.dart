import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../module/note/providers/notes_provider.dart';

class RecentNotesListCard extends StatefulWidget {
  final Function(int noteId)? onNoteTap;
  final int maxNotes;
  final bool autoLoad;

  const RecentNotesListCard({
    Key? key,
    this.onNoteTap,
    this.maxNotes = 10,
    this.autoLoad = true,
  }) : super(key: key);

  @override
  State<RecentNotesListCard> createState() => _RecentNotesListCardState();
}

class _RecentNotesListCardState extends State<RecentNotesListCard> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // 只有当 autoLoad 为 true 时才自动加载笔记
    if (widget.autoLoad) {
      _scheduleLoadNotes();
    }
  }

  void _scheduleLoadNotes() {
    // 使用 addPostFrameCallback 安排在当前构建完成后加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecentNotes();
    });
  }

  Future<void> _loadRecentNotes() async {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    if (notesProvider.recentNotes.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      await notesProvider.loadRecentNotes(refresh: true);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshNotes() async {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    await notesProvider.loadRecentNotes(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Notes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshNotes,
              tooltip: 'Refresh recent notes',
            ),
          ],
        ),
        const Divider(height: 1),
        _buildNotesList(),
      ],
    );
  }

  Widget _buildNotesList() {
    return Consumer<NotesProvider>(
      builder: (context, notesProvider, child) {
        if (_isLoading || notesProvider.isLoading) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final recentNotes = notesProvider.recentNotes;

        if (recentNotes.isEmpty) {
          // 如果笔记为空且未设置自动加载，显示加载按钮
          if (!widget.autoLoad) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _loadRecentNotes,
                  child: const Text('加载笔记'),
                ),
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Text('No recent notes')),
          );
        }

        // Limit the number of notes shown
        final displayedNotes = recentNotes.length > widget.maxNotes
            ? recentNotes.sublist(0, widget.maxNotes)
            : recentNotes;

        return Expanded(
          child: ListView.separated(
            itemCount: displayedNotes.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final noteState = displayedNotes[index];
              final note = noteState.note;

              return ListTile(
                dense: true,
                title: Text(
                  note.noteTitles.first.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  'Updated: ${_formatDateTime(note.updatedAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: noteState.status == NoteOperationStatus.loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      )
                    : const Icon(Icons.chevron_right),
                onTap: widget.onNoteTap != null
                    ? () => widget.onNoteTap!(note.id)
                    : null,
              );
            },
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return DateFormat('MMM d, yyyy').format(dateTime);
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
