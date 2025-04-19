import 'package:openapi/openapi.dart';

/// Represents a chat message in the UI with additional metadata
class ChatMessage {
  /// The content of the message
  final String content;

  /// The role of the message sender (user, assistant, system)
  final String role;

  /// Timestamp when the message was created
  final DateTime timestamp;

  /// Whether the message is currently being generated/streamed
  final bool isGenerating;

  /// Whether there was an error generating this message
  final bool hasError;

  /// Optional error message if hasError is true
  final String? errorMessage;

  ChatMessage({
    required this.content,
    required this.role,
    DateTime? timestamp,
    this.isGenerating = false,
    this.hasError = false,
    this.errorMessage,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Create a user message
  factory ChatMessage.user(String content) {
    return ChatMessage(
      content: content,
      role: 'user',
    );
  }

  /// Create an assistant message
  factory ChatMessage.assistant(String content, {bool isGenerating = false}) {
    return ChatMessage(
      content: content,
      role: 'assistant',
      isGenerating: isGenerating,
    );
  }

  /// Create a system message
  factory ChatMessage.system(String content) {
    return ChatMessage(
      content: content,
      role: 'system',
    );
  }

  /// Create an error message (as assistant)
  factory ChatMessage.error(String errorMessage) {
    return ChatMessage(
      content: 'Error: $errorMessage',
      role: 'assistant',
      hasError: true,
      errorMessage: errorMessage,
    );
  }

  /// Convert to API ChatMessageInput
  ChatMessageInput toApiMessage() {
    return ChatMessageInput((b) => b
      ..content = content
      ..role = role);
  }

  /// Create a copy of this message with modified fields
  ChatMessage copyWith({
    String? content,
    String? role,
    DateTime? timestamp,
    bool? isGenerating,
    bool? hasError,
    String? errorMessage,
  }) {
    return ChatMessage(
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      isGenerating: isGenerating ?? this.isGenerating,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
