import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_manager.dart';
import 'package:raysystem_flutter/commands/command.dart';
import 'package:raysystem_flutter/module/note/providers/notes_provider.dart';
import 'package:raysystem_flutter/card/note_card.dart';
import 'package:raysystem_flutter/card/recent_notes_list_card.dart';

final noteCommands = Command(
  command: 'note-app',
  title: '笔记应用',
  icon: Icons.note,
  subCommands: [
    Command(
      command: 'note-add',
      title: '添加笔记',
      icon: Icons.add,
      callback: (context, cardManager) {
        // Create a new blank note card
        cardManager.addCard(
          SizedBox(
            height: 400,
            child: NoteCard(
              // No ID means creating a new note
              isEditable: true,
            ),
          ),
        );
      },
    ),
    Command(
      command: 'note-list',
      title: '查看笔记列表',
      icon: Icons.list,
      callback: (context, cardManager) {
        // 添加笔记列表卡片，使用 autoLoad 属性避免在构建过程中加载数据
        cardManager.addCard(
          SizedBox(
            height: 400,
            child: RecentNotesListCard(
              autoLoad: false, // 不在构建过程中自动加载
              onNoteTap: (noteId) {
                // When a note is tapped, open it in a new card
                cardManager.addCard(
                  SizedBox(
                    height: 400,
                    child: NoteCard(
                      noteId: noteId,
                      isEditable: true,
                    ),
                  ),
                );
              },
            ),
          ),
        );

        // 在下一帧中安全地加载笔记
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final notesProvider =
              Provider.of<NotesProvider>(context, listen: false);
          notesProvider.loadRecentNotes(refresh: true);
        });
      },
    ),
    Command(
      command: 'note-search',
      title: '搜索笔记',
      icon: Icons.search,
      callback: (context, cardManager) {
        // Create a search interface for notes
        final searchController = TextEditingController();

        cardManager.addCard(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: '输入关键词搜索笔记',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (query) {
                          if (query.isNotEmpty) {
                            _performSearch(context, cardManager, query);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        final query = searchController.text.trim();
                        if (query.isNotEmpty) {
                          _performSearch(context, cardManager, query);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '输入关键词后点击搜索或按回车键进行搜索',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ],
);

// Helper function to perform search and display results
void _performSearch(
    BuildContext context, CardManager cardManager, String query) {
  // 安全地添加搜索卡片
  cardManager.addCard(
    SizedBox(
      height: 400,
      child: _SearchResultsCard(
        searchQuery: query,
        onNoteTap: (noteId) {
          // When a note is tapped, open it in a new card
          cardManager.addCard(
            SizedBox(
              height: 400,
              child: NoteCard(
                noteId: noteId,
                isEditable: true,
              ),
            ),
          );
        },
      ),
    ),
  );

  // 在下一帧中安全地执行搜索
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    notesProvider.searchNotes(query);
  });
}

// 搜索结果卡片组件
class _SearchResultsCard extends StatelessWidget {
  final String searchQuery;
  final Function(int noteId) onNoteTap;

  const _SearchResultsCard({
    required this.searchQuery,
    required this.onNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '搜索结果: "$searchQuery"',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _SearchResultsList(
              searchQuery: searchQuery,
              onNoteTap: onNoteTap,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget to display search results
class _SearchResultsList extends StatelessWidget {
  final String searchQuery;
  final Function(int noteId) onNoteTap;

  const _SearchResultsList({
    required this.searchQuery,
    required this.onNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<NotesProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.hasError) {
          return Center(
            child: Text(
              provider.errorMessage ?? '搜索出错',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }

        // Filter notes by the search query
        final notes = provider.allNotes;

        if (notes.isEmpty) {
          return const Center(child: Text('没有找到匹配的笔记'));
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: notes.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final noteState = notes[index];
            final note = noteState.note;

            return ListTile(
              title: Text(
                note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '最后更新: ${_formatDateTime(note.updatedAt)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onNoteTap(note.id),
            );
          },
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
