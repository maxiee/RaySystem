import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/chat_message.dart';

/// A UI component for displaying a chat message bubble
class ChatMessageBubble extends StatelessWidget {
  /// The message to display
  final ChatMessage message;

  /// Whether to show the message timestamp
  final bool showTimestamp;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.showTimestamp = true,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final isSystem = message.role == 'system';

    return Padding(
      // Add some vertical spacing between messages
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // For non-user messages, show an avatar/icon
          if (!isUser) _buildAvatar(context, isSystem),

          // Add some spacing
          const SizedBox(width: 8),

          // Main message bubble
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // Message bubble with content
                _buildBubble(context, isUser, isSystem),

                // Optional timestamp
                if (showTimestamp) _buildTimestamp(context),
              ],
            ),
          ),

          // Add some spacing
          const SizedBox(width: 8),

          // For user messages, show an avatar/icon
          if (isUser) _buildAvatar(context, isSystem),
        ],
      ),
    );
  }

  /// Build the avatar/icon for the message
  Widget _buildAvatar(BuildContext context, bool isSystem) {
    IconData iconData;
    Color backgroundColor;
    Color iconColor;

    if (message.role == 'user') {
      iconData = Icons.person;
      backgroundColor = Theme.of(context).colorScheme.secondaryContainer;
      iconColor = Theme.of(context).colorScheme.onSecondaryContainer;
    } else if (isSystem) {
      iconData = Icons.settings;
      backgroundColor = Theme.of(context).colorScheme.tertiaryContainer;
      iconColor = Theme.of(context).colorScheme.onTertiaryContainer;
    } else {
      iconData = Icons.smart_toy;
      backgroundColor = Theme.of(context).colorScheme.primaryContainer;
      iconColor = Theme.of(context).colorScheme.onPrimaryContainer;
    }

    return CircleAvatar(
      radius: 16,
      backgroundColor: backgroundColor,
      child: Icon(
        iconData,
        size: 16,
        color: iconColor,
      ),
    );
  }

  /// Build the main message bubble
  Widget _buildBubble(BuildContext context, bool isUser, bool isSystem) {
    // Select colors based on message role
    Color bubbleColor;
    Color textColor;

    if (isUser) {
      bubbleColor = Theme.of(context).colorScheme.secondaryContainer;
      textColor = Theme.of(context).colorScheme.onSecondaryContainer;
    } else if (isSystem) {
      bubbleColor = Theme.of(context).colorScheme.tertiaryContainer;
      textColor = Theme.of(context).colorScheme.onTertiaryContainer;
    } else if (message.hasError) {
      bubbleColor = Theme.of(context).colorScheme.errorContainer;
      textColor = Theme.of(context).colorScheme.onErrorContainer;
    } else {
      bubbleColor = Theme.of(context).colorScheme.primaryContainer;
      textColor = Theme.of(context).colorScheme.onPrimaryContainer;
    }

    return Material(
      color: bubbleColor,
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: () => _showContextMenu(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display role as a badge for system messages
              if (isSystem)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'System',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                ),

              // Message content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Always show content, even when generating
                  if (message.content.isNotEmpty)
                    SelectableText(
                      message.content.trimLeft(), // Trim leading whitespace
                      style: TextStyle(
                        color: textColor,
                      ),
                    ),

                  // Show generating indicator if still generating
                  if (message.isGenerating)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: _buildGeneratingIndicator(context, textColor),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the timestamp display
  Widget _buildTimestamp(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
      child: Text(
        _formatTime(message.timestamp),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
      ),
    );
  }

  /// Build the loading indicator for generating messages
  Widget _buildGeneratingIndicator(BuildContext context, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: textColor,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '...',
          style: TextStyle(
            color: textColor,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  /// Show a context menu with options for the message
  void _showContextMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: 'copy',
          child: const Row(
            children: [
              Icon(Icons.copy, size: 18),
              SizedBox(width: 8),
              Text('Copy text'),
            ],
          ),
          onTap: () {
            Clipboard.setData(ClipboardData(text: message.content));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Message copied to clipboard'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }

  /// Format a timestamp into a readable string
  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      // For today, show just the time
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      // For other days, include the date
      return '${time.day}/${time.month} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}
