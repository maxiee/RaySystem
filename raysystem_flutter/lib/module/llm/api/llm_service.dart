import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import '../../../api/api.dart';

/// Interface for LLM service operations
abstract class LLMService {
  /// Get list of available LLM models
  Future<List<ModelInfo>> getAvailableModels();

  /// Send a chat completion request and get response
  Future<ChatCompletionResponse?> sendChatCompletion({
    required List<ChatMessageInput> messages,
    String? modelId,
    double temperature = 0.7,
    int? maxTokens,
  });
}

/// Implementation of LLMService using the generated API client
class ApiLLMService implements LLMService {
  final LLMApi _llmApi;

  ApiLLMService({required LLMApi llmApi}) : _llmApi = llmApi;

  @override
  Future<List<ModelInfo>> getAvailableModels() async {
    try {
      final response = await _llmApi.listModelsEndpointLlmModelsGet();
      return response.data?.models?.toList() ?? [];
    } catch (e) {
      debugPrint('Error getting available models: $e');
      return [];
    }
  }

  @override
  Future<ChatCompletionResponse?> sendChatCompletion({
    required List<ChatMessageInput> messages,
    String? modelId,
    double temperature = 0.7,
    int? maxTokens,
  }) async {
    try {
      final request = ChatCompletionRequest((b) => b
        ..messages.replace(messages)
        ..modelName = modelId);

      final response = await _llmApi.chatCompletionEndpointLlmChatPost(
        chatCompletionRequest: request,
      );

      return response.data;
    } catch (e) {
      debugPrint('Error sending chat completion: $e');
      return null;
    }
  }
}
