import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart';
import 'package:dio/dio.dart';
import 'chat_message.dart';
import 'chat_prompt.dart';
import 'chat_session_model.dart';

/// Represents a chat session with conversation history and settings
class ChatSession extends ChangeNotifier {
  /// List of messages in the conversation
  List<ChatMessage> _messages = [];

  /// Currently selected model ID
  String? _selectedModelId;

  /// Available LLM models
  List<ModelInfo> _availableModels = [];

  /// Temperature setting for generation (0.0-1.0)
  double _temperature = 0.7;

  /// Whether a message is currently being generated
  bool _isGenerating = false;

  /// Currently selected prompt/role
  ChatPrompt? _selectedPrompt;

  /// List of available prompts
  final List<ChatPrompt> _availablePrompts = ChatPromptService.getAllPrompts();

  /// Cancel token for active streaming requests
  CancelToken? _streamCancelToken;

  /// Constructor with optional initial settings
  ChatSession({
    List<ChatMessage>? initialMessages,
    String? selectedModelId,
    List<ModelInfo>? availableModels,
    double? temperature,
    ChatPrompt? selectedPrompt,
  }) {
    _messages = initialMessages ?? [];
    _selectedModelId = selectedModelId;
    _availableModels = availableModels ?? [];
    _temperature = temperature ?? 0.7;
    _selectedPrompt = selectedPrompt;
  }

  /// Get all messages in the conversation
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  /// Get the currently selected model ID
  String? get selectedModelId => _selectedModelId;

  /// Set the selected model ID
  set selectedModelId(String? modelId) {
    _selectedModelId = modelId;
    notifyListeners();
  }

  /// Get all available models
  List<ModelInfo> get availableModels => List.unmodifiable(_availableModels);

  /// Set the available models
  set availableModels(List<ModelInfo> models) {
    _availableModels = models;
    notifyListeners();
  }

  /// Get the current temperature setting
  double get temperature => _temperature;

  /// Set the temperature setting
  set temperature(double value) {
    _temperature = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  /// Check if a message is currently being generated
  bool get isGenerating => _isGenerating;

  /// Set the generating state
  set isGenerating(bool value) {
    _isGenerating = value;
    notifyListeners();
  }

  /// Get the currently selected prompt
  ChatPrompt? get selectedPrompt => _selectedPrompt;

  /// Set the selected prompt
  set selectedPrompt(ChatPrompt? prompt) {
    _selectedPrompt = prompt;
    notifyListeners();
  }

  /// Get all available prompts
  List<ChatPrompt> get availablePrompts => List.unmodifiable(_availablePrompts);

  /// Apply the currently selected prompt
  void applySelectedPrompt() {
    if (_selectedPrompt != null) {
      // Clear any existing system messages
      _messages.removeWhere((message) => message.role == 'system');

      // Add new system message with the prompt text
      addSystemMessage(_selectedPrompt!.promptText);
    }
  }

  /// Add a user message to the conversation
  void addUserMessage(String content) {
    _messages.add(ChatMessage.user(content));
    notifyListeners();
  }

  /// Add a system message to the conversation
  void addSystemMessage(String content) {
    _messages.add(ChatMessage.system(content));
    notifyListeners();
  }

  /// Start generating an assistant message
  ChatMessage startAssistantMessage() {
    final message = ChatMessage.assistant('', isGenerating: true);
    _messages.add(message);
    _isGenerating = true;
    notifyListeners();
    return message;
  }

  /// Update the content of the last assistant message
  void updateLastAssistantMessage(String content) {
    if (_messages.isNotEmpty && _messages.last.role == 'assistant') {
      final index = _messages.length - 1;
      _messages[index] = _messages[index].copyWith(content: content);
      notifyListeners();
    }
  }

  /// Append content to the last assistant message (for streaming)
  void appendToLastAssistantMessage(String content) {
    if (_messages.isNotEmpty && _messages.last.role == 'assistant') {
      final index = _messages.length - 1;
      final currentContent = _messages[index].content;
      _messages[index] =
          _messages[index].copyWith(content: currentContent + content);
      notifyListeners();
    }
  }

  /// Complete the generation of the last assistant message
  void completeLastAssistantMessage({bool updateContent = true}) {
    if (_messages.isNotEmpty && _messages.last.role == 'assistant') {
      final index = _messages.length - 1;
      final lastMessage = _messages[index];

      // Create a copy of the message with isGenerating set to false
      // If updateContent is false, keep the existing content to avoid duplication
      _messages[index] = lastMessage.copyWith(
        isGenerating: false,
        // No need to provide content when updateContent is false
        // When updateContent is true, using the existing content (no change)
      );

      _isGenerating = false;
      _streamCancelToken = null; // Clear the cancel token when complete
      notifyListeners();
    }
  }

  /// Add an error message to the conversation
  void addErrorMessage(String errorMessage) {
    _messages.add(ChatMessage.error(errorMessage));
    _isGenerating = false;
    _streamCancelToken = null; // Clear the cancel token on error
    notifyListeners();
  }

  /// Clear all messages in the conversation
  void clearMessages() {
    _messages = [];
    notifyListeners();
  }

  /// Convert all messages to API format for sending to backend
  List<ChatMessageInput> toApiMessages() {
    return _messages.map((msg) => msg.toApiMessage()).toList();
  }

  /// Get the current cancel token or create a new one
  CancelToken getOrCreateCancelToken() {
    _streamCancelToken ??= CancelToken();
    return _streamCancelToken!;
  }

  /// Cancel any ongoing streaming request
  void cancelStreamingRequest() {
    if (_streamCancelToken != null && !_streamCancelToken!.isCancelled) {
      _streamCancelToken!.cancel('User cancelled the request');
      _streamCancelToken = null;
    }
  }

  /// Load the chat session from a session model
  void loadFromSessionModel(ChatSessionModel model) {
    try {
      // First clear existing messages
      _messages = []; // Directly clear the internal list

      // Set model name if available
      if (model.modelName.isNotEmpty) {
        selectedModelId = model.modelName;
      }

      // Parse the content JSON
      final parsedMessageMaps = model.parseContent();

      // Add each message to the chat session
      for (final msgMap in parsedMessageMaps) {
        final role = msgMap['role'] as String?;
        final content = msgMap['content'] as String?;

        if (role == null || content == null) continue;

        // Create a message based on the role and add it directly to _messages
        switch (role) {
          case 'user':
            _messages.add(ChatMessage.user(content));
            break;
          case 'assistant':
            _messages.add(ChatMessage.assistant(content));
            break;
          case 'system':
            _messages.add(ChatMessage.system(content));
            break;
          case 'error':
            _messages.add(ChatMessage.error(content));
            break;
        }
      }

      // Notify listeners after all messages are loaded
      notifyListeners();
    } catch (e) {
      // Start with a clean slate if there's an error
      _messages = [];

      // If parsing fails, add an error message
      addErrorMessage('Failed to load chat session: $e');
    }
  }

  /// Add an assistant message directly (without generating indicator)
  void addAssistantMessageDirect(String content) {
    _messages.add(ChatMessage.assistant(content, isGenerating: false));
    notifyListeners();
  }

  @override
  void dispose() {
    // Make sure to cancel any ongoing requests when disposed
    cancelStreamingRequest();
    super.dispose();
  }
}
