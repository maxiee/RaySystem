import 'package:flutter/material.dart';

/// A text input field for sending chat messages with submit functionality
class ChatInputField extends StatefulWidget {
  /// Callback for when a message is submitted
  final Function(String) onSubmit;

  /// Whether the input is currently enabled
  final bool enabled;

  /// Optional placeholder text
  final String? placeholder;

  const ChatInputField({
    super.key,
    required this.onSubmit,
    this.enabled = true,
    this.placeholder,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChange() {
    setState(() {
      _isEmpty = _controller.text.trim().isEmpty;
    });
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmit(text);
      _controller.clear();
      // Keep focus on the input field after sending
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          // Message input field
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              decoration: InputDecoration(
                hintText: widget.placeholder ?? 'Type a message...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              maxLines: 5,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.send,
              onSubmitted: (text) {
                if (widget.enabled) {
                  _handleSubmit();
                }
              },
            ),
          ),

          // Send button
          IconButton(
            icon: Icon(
              Icons.send_rounded,
              color: _isEmpty || !widget.enabled
                  ? Theme.of(context).colorScheme.outline
                  : Theme.of(context).colorScheme.primary,
            ),
            onPressed: (_isEmpty || !widget.enabled) ? null : _handleSubmit,
            tooltip: 'Send message',
          ),
        ],
      ),
    );
  }
}
