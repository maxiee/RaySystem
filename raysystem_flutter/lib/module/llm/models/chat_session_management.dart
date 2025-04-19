import 'dart:convert';
import 'chat_session.dart';

/// Extension on ChatSession to add session management functionality
extension ChatSessionManagement on ChatSession {
  /// Convert the current chat messages to JSON format for storage
  String toContentJson() {
    final messagesJson = messages.map((message) {
      return {
        'role': message.role,
        'content': message.content,
        'timestamp': message.timestamp.toIso8601String(),
      };
    }).toList();

    return jsonEncode(messagesJson);
  }

  // loadFromSessionModel method has been moved to ChatSession class

  // These methods are now handled by the ChatSession class directly
}
