import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

/// tests for LLMApi
void main() {
  final instance = Openapi().getLLMApi();

  group(LLMApi, () {
    // Generate Chat Completion
    //
    // Sends a conversation history to the configured LLM and returns the next message.
    //
    //Future<ChatCompletionResponse> chatCompletionEndpointLlmChatPost(ChatCompletionRequest chatCompletionRequest) async
    test('test chatCompletionEndpointLlmChatPost', () async {
      // TODO
    });

    // List Available LLM Models
    //
    // Returns a list of available LLM models that can be used for chat completions.
    //
    //Future<ListModelsResponse> listModelsEndpointLlmModelsGet() async
    test('test listModelsEndpointLlmModelsGet', () async {
      // TODO
    });
  });
}
