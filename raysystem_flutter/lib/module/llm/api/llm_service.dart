import 'dart:async';

import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';
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

  /// Send a streaming chat completion request and get a stream of responses
  Future<Stream<String>> sendStreamingChatCompletion({
    required List<ChatMessageInput> messages,
    String? modelId,
    double temperature = 0.7,
    int? maxTokens,
    CancelToken? cancelToken,
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
      return response.data?.models.toList() ?? [];
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

  @override
  Future<Stream<String>> sendStreamingChatCompletion({
    required List<ChatMessageInput> messages,
    String? modelId,
    double temperature = 0.7,
    int? maxTokens,
    CancelToken? cancelToken,
  }) async {
    try {
      final request = ChatCompletionRequest((b) => b
        ..messages.replace(messages)
        ..modelName = modelId);

      // Use the global llmStreamAPI to get a stream of content
      return await llmStreamAPI.streamContent(
        request: request,
        cancelToken: cancelToken,
      );
    } catch (e) {
      debugPrint('Error sending streaming chat completion: $e');
      // Return an empty stream with an error
      final controller = StreamController<String>();
      controller.addError(e);
      controller.close();
      return controller.stream;
    }
  }
}
