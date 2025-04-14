import 'package:flutter/foundation.dart';
import 'package:openapi/openapi.dart';
import 'chat_message.dart';
import 'chat_prompt.dart';

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
  List<ChatPrompt> _availablePrompts = ChatPromptService.getAllPrompts();

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

  /// Complete the generation of the last assistant message
  void completeLastAssistantMessage() {
    if (_messages.isNotEmpty && _messages.last.role == 'assistant') {
      final index = _messages.length - 1;
      _messages[index] = _messages[index].copyWith(isGenerating: false);
      _isGenerating = false;
      notifyListeners();
    }
  }

  /// Add an error message to the conversation
  void addErrorMessage(String errorMessage) {
    _messages.add(ChatMessage.error(errorMessage));
    _isGenerating = false;
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
}
