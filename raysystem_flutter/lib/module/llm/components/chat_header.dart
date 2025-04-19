import 'package:flutter/material.dart';
import '../models/chat_session.dart';

/// Widget that displays the chat header with title and action buttons
class ChatHeader extends StatelessWidget {
  final ChatSession chatSession;
  final String? sessionTitle;
  final bool showSessionsSidebar;
  final bool showPrompts;
  final bool showSettings;
  final VoidCallback onToggleSessionsSidebar;
  final VoidCallback onTogglePrompts;
  final VoidCallback onToggleSettings;
  final VoidCallback? onClearChat;

  const ChatHeader({
    super.key,
    required this.chatSession,
    this.sessionTitle,
    required this.showSessionsSidebar,
    required this.showPrompts,
    required this.showSettings,
    required this.onToggleSessionsSidebar,
    required this.onTogglePrompts,
    required this.onToggleSettings,
    this.onClearChat,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = sessionTitle != null ? sessionTitle! : 'LLM Chat';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Card title with session indicator if applicable
          Icon(
            Icons.chat,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            displayTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),

          // Session management button (only shown when sidebar is hidden)
          if (!showSessionsSidebar)
            IconButton(
              icon: const Icon(Icons.folder_outlined, size: 20),
              onPressed: onToggleSessionsSidebar,
              tooltip: 'Manage chat sessions',
            ),

          // Prompt templates toggle
          IconButton(
            icon: Icon(
              showPrompts ? Icons.psychology_outlined : Icons.psychology,
              size: 20,
            ),
            onPressed: onTogglePrompts,
            tooltip: showPrompts ? 'Hide prompts' : 'Show prompts',
          ),

          // Settings toggle
          IconButton(
            icon: Icon(
              showSettings ? Icons.settings_outlined : Icons.settings,
              size: 20,
            ),
            onPressed: onToggleSettings,
            tooltip: showSettings ? 'Hide settings' : 'Show settings',
          ),

          // Clear conversation button
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: chatSession.messages.isEmpty ? null : onClearChat,
            tooltip: 'Clear conversation',
          ),
        ],
      ),
    );
  }
}
