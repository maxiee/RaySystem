import 'dart:convert';
import 'package:openapi/openapi.dart';

/// Model class representing a chat session stored on the server
class ChatSessionModel {
  final int id;
  final String title;
  final String modelName;
  final String contentJson;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatSessionModel({
    required this.id,
    required this.title,
    required this.modelName,
    required this.contentJson,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a chat session model from API response
  factory ChatSessionModel.fromResponse(ChatSessionResponse response) {
    return ChatSessionModel(
      id: response.id,
      title: response.title,
      modelName: response.modelName ?? '',
      contentJson: response.contentJson,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  /// Parse the content JSON into a list of message maps
  List<Map<String, dynamic>> parseContent() {
    try {
      final List<dynamic> parsedJson = jsonDecode(contentJson);
      return parsedJson.cast<Map<String, dynamic>>();
    } catch (e) {
      // Return empty list if parsing fails
      return [];
    }
  }

  /// Create a request object for updating this session
  ChatSessionUpdate toUpdateRequest({
    String? newTitle,
    String? newModelName,
    String? newContentJson,
  }) {
    return ChatSessionUpdate((b) => b
      ..title = newTitle
      ..modelName = newModelName
      ..contentJson = newContentJson);
  }
}
