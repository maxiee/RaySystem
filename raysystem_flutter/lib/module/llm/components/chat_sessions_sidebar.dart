import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import '../models/chat_session.dart';
import '../models/chat_session_model.dart';

/// A sidebar widget to manage chat sessions (list, create, select, delete)
class ChatSessionsSidebar extends StatefulWidget {
  final LLMApi llmApi;
  final Function(ChatSessionModel) onSessionSelected;
  final Function(bool) onSidebarToggle;
  final bool isOpen;
  final ChatSession currentChatSession;

  const ChatSessionsSidebar({
    super.key,
    required this.llmApi,
    required this.onSessionSelected,
    required this.onSidebarToggle,
    required this.isOpen,
    required this.currentChatSession,
  });

  @override
  State<ChatSessionsSidebar> createState() => _ChatSessionsSidebarState();
}

class _ChatSessionsSidebarState extends State<ChatSessionsSidebar> {
  // List of chat sessions
  List<ChatSessionModel> _chatSessions = [];
  bool _isLoading = false;
  int? _selectedSessionId;
  bool _creatingNewSession = false;
  final TextEditingController _titleController = TextEditingController();

  // Pagination
  static const int _pageSize = 20;
  int _currentOffset = 0;
  int _totalSessions = 0;
  bool _hasMoreSessions = true;

  @override
  void initState() {
    super.initState();
    if (widget.isOpen) {
      _loadChatSessions();
    }
  }

  @override
  void didUpdateWidget(ChatSessionsSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isOpen && !oldWidget.isOpen) {
      _loadChatSessions();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  /// Load chat sessions from the API
  Future<void> _loadChatSessions({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (refresh) {
        _currentOffset = 0;
        _chatSessions = [];
      }
    });

    try {
      final response = await widget.llmApi.listChatSessionsLlmChatSessionsGet(
        limit: _pageSize,
        offset: _currentOffset,
      );

      // 解析数据
      final newSessions = <ChatSessionModel>[];

      if (response.data != null) {
        for (final item in response.data!.items) {
          newSessions.add(ChatSessionModel(
            id: item.id,
            title: item.title,
            modelName: item.modelName ?? '',
            contentJson: item.contentJson,
            createdAt: DateTime.parse(item.createdAt.toString()),
            updatedAt: DateTime.parse(item.updatedAt.toString()),
          ));
        }
      }

      setState(() {
        if (refresh || _currentOffset == 0) {
          _chatSessions = newSessions;
        } else {
          _chatSessions.addAll(newSessions);
        }
        _isLoading = false;
        _totalSessions = response.data?.total ?? 0;
        _hasMoreSessions = _chatSessions.length < _totalSessions;
        _currentOffset = _chatSessions.length;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackbar('Failed to load chat sessions: ${e.toString()}');
    }
  }

  /// Show an error message in a snackbar
  void _showErrorSnackbar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  /// Create a new chat session
  Future<void> _createChatSession() async {
    if (_titleController.text.isEmpty) {
      _showErrorSnackbar('Please enter a title for the chat session');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 创建新会话时，contentJson 设为空数组
      final contentJson = jsonEncode([]);

      // 创建请求体
      final request = ChatSessionCreate((b) {
        b.title = _titleController.text;
        b.modelName = widget.currentChatSession.selectedModelId;
        b.contentJson = contentJson;
      });

      // 发送API请求
      final response = await widget.llmApi.createChatSessionLlmChatSessionsPost(
        chatSessionCreate: request,
      );

      if (response.data != null) {
        // 创建新会话模型
        final newSession = ChatSessionModel(
          id: response.data!.id,
          title: response.data!.title,
          modelName: response.data?.modelName ?? '',
          contentJson: response.data!.contentJson,
          createdAt: DateTime.parse(response.data!.createdAt.toString()),
          updatedAt: DateTime.parse(response.data!.updatedAt.toString()),
        );

        setState(() {
          _chatSessions.insert(0, newSession);
          _selectedSessionId = newSession.id;
          _creatingNewSession = false;
          _titleController.clear();
        });

        // 通知父组件切换到新会话
        widget.onSessionSelected(newSession);

        // 显示成功消息
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chat session created'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      _showErrorSnackbar('Failed to create chat session: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Delete a chat session
  Future<void> _deleteChatSession(int sessionId) async {
    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat Session'),
        content: const Text(
            'Are you sure you want to delete this chat session? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final response =
          await widget.llmApi.deleteChatSessionLlmChatSessionsSessionIdDelete(
        sessionId: sessionId,
      );

      if (response.data == true) {
        setState(() {
          _chatSessions.removeWhere((session) => session.id == sessionId);
          if (_selectedSessionId == sessionId) {
            _selectedSessionId = null;
          }
        });
      } else {
        _showErrorSnackbar('Failed to delete chat session');
      }
    } catch (e) {
      _showErrorSnackbar('Error deleting chat session: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Load a selected chat session
  Future<void> _loadChatSession(ChatSessionModel session) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _selectedSessionId = session.id;
    });

    try {
      final response =
          await widget.llmApi.getChatSessionLlmChatSessionsSessionIdGet(
        sessionId: session.id,
      );

      if (response.data != null) {
        // 创建更新的模型
        final loadedSession = ChatSessionModel(
          id: response.data!.id,
          title: response.data!.title,
          modelName: response.data?.modelName ?? '',
          contentJson: response.data!.contentJson,
          createdAt: DateTime.parse(response.data!.createdAt.toString()),
          updatedAt: DateTime.parse(response.data!.updatedAt.toString()),
        );

        // 通知父组件
        widget.onSessionSelected(loadedSession);
      }
    } catch (e) {
      _showErrorSnackbar('Failed to load chat session: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Save current session
  Future<void> _saveCurrentSession() async {
    final currentSession = widget.currentChatSession;

    // 如果没有选中会话，则创建新会话
    if (_selectedSessionId == null) {
      setState(() => _creatingNewSession = true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 准备当前会话的内容JSON
      final contentJson = jsonEncode(currentSession.messages
          .map((msg) => {
                'role': msg.role,
                'content': msg.content,
                'timestamp': msg.timestamp.toIso8601String(),
              })
          .toList());

      // 创建更新请求体
      final request = ChatSessionUpdate((b) {
        b.contentJson = contentJson;
      });

      // 发送API请求
      final response =
          await widget.llmApi.updateChatSessionLlmChatSessionsSessionIdPut(
        sessionId: _selectedSessionId!,
        chatSessionUpdate: request,
      );

      if (response.data != null) {
        // 更新列表中的会话
        setState(() {
          final index =
              _chatSessions.indexWhere((s) => s.id == _selectedSessionId);
          if (index >= 0) {
            _chatSessions[index] = ChatSessionModel(
              id: response.data!.id,
              title: response.data!.title,
              modelName: response.data?.modelName ?? '',
              contentJson: response.data!.contentJson,
              createdAt: DateTime.parse(response.data!.createdAt.toString()),
              updatedAt: DateTime.parse(response.data!.updatedAt.toString()),
            );
          }
        });

        // 显示成功消息
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chat session saved'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      _showErrorSnackbar('Failed to save chat session: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // If sidebar is closed, only show a handle to open it
    if (!widget.isOpen) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 24,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(right: BorderSide(color: theme.dividerColor)),
        ),
        child: InkWell(
          onTap: () => widget.onSidebarToggle(true),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Icon(
                Icons.chevron_right,
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 280,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(right: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(theme),

          // Divider
          const Divider(height: 1),

          // Sessions list or create form
          Expanded(
            child: _creatingNewSession
                ? _buildCreateSessionForm()
                : _buildSessionsList(),
          ),

          // Bottom action buttons
          _buildActionButtons(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Text(
            'Chat Sessions',
            style: theme.textTheme.titleMedium,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20),
            onPressed: () => widget.onSidebarToggle(false),
            tooltip: 'Close sidebar',
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList() {
    return Stack(
      children: [
        // Sessions list
        RefreshIndicator(
          onRefresh: () => _loadChatSessions(refresh: true),
          child: _chatSessions.isEmpty && !_isLoading
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: _chatSessions.length + (_hasMoreSessions ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _chatSessions.length) {
                      return _buildLoadMoreButton();
                    }
                    return _buildSessionTile(_chatSessions[index]);
                  },
                ),
        ),

        // Loading indicator
        if (_isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No saved sessions',
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => setState(() => _creatingNewSession = true),
            icon: const Icon(Icons.add),
            label: const Text('Create new session'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _isLoading ? null : () => _loadChatSessions(),
        child: const Text('Load more'),
      ),
    );
  }

  Widget _buildSessionTile(ChatSessionModel session) {
    final isSelected = _selectedSessionId == session.id;
    final theme = Theme.of(context);

    return ListTile(
      title: Text(
        session.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${session.modelName} • ${_formatDate(session.updatedAt)}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall,
      ),
      selected: isSelected,
      selectedTileColor: theme.colorScheme.secondaryContainer,
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, size: 18),
        onPressed: () => _deleteChatSession(session.id),
        tooltip: 'Delete session',
      ),
      onTap: () => _loadChatSession(session),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  Widget _buildCreateSessionForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create New Session',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Session Title',
              hintText: 'Enter a name for this chat session',
              border: OutlineInputBorder(),
            ),
            maxLength: 100,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => setState(() => _creatingNewSession = false),
                child: const Text('CANCEL'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isLoading ? null : _createChatSession,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('SAVE'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => setState(() => _creatingNewSession = true),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed:
                  _selectedSessionId != null ? _saveCurrentSession : null,
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
