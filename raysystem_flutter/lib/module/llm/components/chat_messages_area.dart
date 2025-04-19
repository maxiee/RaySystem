import 'package:flutter/material.dart';
import '../models/chat_session.dart';
import 'chat_message_bubble.dart';

/// Widget that displays the chat messages area
class ChatMessagesArea extends StatelessWidget {
  final ChatSession chatSession;
  final ScrollController scrollController;

  const ChatMessagesArea({
    super.key,
    required this.chatSession,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final messages = chatSession.messages;

    return messages.isEmpty
        ? const EmptyChatPlaceholder()
        : ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return ChatMessageBubble(
                message: messages[index],
              );
            },
          );
  }
}

/// Placeholder widget shown when the chat is empty
class EmptyChatPlaceholder extends StatelessWidget {
  const EmptyChatPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Start a conversation',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Type a message below to chat with an AI assistant',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
