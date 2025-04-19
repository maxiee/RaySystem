import 'dart:convert';
import 'package:raysystem_flutter/module/llm/models/chat_message.dart';

import 'chat_session.dart';
import 'chat_session_model.dart';

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

  /// Load messages from a chat session model
  void loadFromSessionModel(ChatSessionModel model) {
    // Clear existing messages
    clearMessages();

    // Set model name if available
    if (model.modelName.isNotEmpty) {
      selectedModelId = model.modelName;
    }

    // Parse the content JSON
    try {
      final List<dynamic> messagesJson = jsonDecode(model.contentJson);

      // Add each message to the chat session
      for (final msgJson in messagesJson) {
        if (msgJson is Map<String, dynamic>) {
          final role = msgJson['role'] as String;
          final content = msgJson['content'] as String;
          final timestamp = msgJson['timestamp'] != null
              ? DateTime.parse(msgJson['timestamp'] as String)
              : DateTime.now();

          if (role == 'user') {
            addUserMessage(content);
          } else if (role == 'assistant') {
            addAssistantMessageDirect(content, timestamp: timestamp);
          } else if (role == 'system') {
            addSystemMessage(content, timestamp: timestamp);
          } else if (role == 'error') {
            addErrorMessage(
              content,
            );
          }
        }
      }
    } catch (e) {
      // If parsing fails, add an error message
      addErrorMessage('Failed to load chat session: $e');
    }
  }

  /// Add a system message to the chat
  void addSystemMessage(String message, {DateTime? timestamp}) {
    messages.add(ChatMessage(
      role: 'system',
      content: message,
      timestamp: timestamp ?? DateTime.now(),
    ));
    notifyListeners();
  }

  /// Add an assistant message directly (without generating indicator)
  void addAssistantMessageDirect(String message, {DateTime? timestamp}) {
    messages.add(ChatMessage(
      role: 'assistant',
      content: message,
      timestamp: timestamp ?? DateTime.now(),
    ));
    notifyListeners();
  }
}
