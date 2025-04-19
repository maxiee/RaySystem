import 'package:test/test.dart';
import 'package:openapi/openapi.dart';

/// tests for ChatSessionsApi
void main() {
  final instance = Openapi().getChatSessionsApi();

  group(ChatSessionsApi, () {
    // Create Chat Session
    //
    // Create a new chat session with the specified title, model name, and content
    //
    //Future<ChatSessionResponse> createChatSessionLlmChatSessionsPost_0(ChatSessionCreate chatSessionCreate) async
    test('test createChatSessionLlmChatSessionsPost_0', () async {
      // TODO
    });

    // Delete Chat Session
    //
    // Delete a chat session by ID
    //
    //Future<bool> deleteChatSessionLlmChatSessionsSessionIdDelete_0(int sessionId) async
    test('test deleteChatSessionLlmChatSessionsSessionIdDelete_0', () async {
      // TODO
    });

    // Get Chat Session
    //
    // Get a specific chat session by ID
    //
    //Future<ChatSessionResponse> getChatSessionLlmChatSessionsSessionIdGet_0(int sessionId) async
    test('test getChatSessionLlmChatSessionsSessionIdGet_0', () async {
      // TODO
    });

    // List Chat Sessions
    //
    // List recently updated chat sessions sorted by update time (newest first)
    //
    //Future<ChatSessionsListResponse> listChatSessionsLlmChatSessionsGet_0({ int limit, int offset }) async
    test('test listChatSessionsLlmChatSessionsGet_0', () async {
      // TODO
    });

    // Update Chat Session
    //
    // Update an existing chat session
    //
    //Future<ChatSessionResponse> updateChatSessionLlmChatSessionsSessionIdPut_0(int sessionId, ChatSessionUpdate chatSessionUpdate) async
    test('test updateChatSessionLlmChatSessionsSessionIdPut_0', () async {
      // TODO
    });
  });
}
