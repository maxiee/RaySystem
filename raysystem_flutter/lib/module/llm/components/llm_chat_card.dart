import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../api/api.dart';
import '../api/llm_service.dart';
import '../models/chat_session.dart';
import 'chat_input_field.dart';
import 'chat_message_bubble.dart';
import 'chat_settings_panel.dart';
import 'prompt_selector.dart';

/// A card widget that displays an LLM chat interface
class LLMChatCard extends StatefulWidget {
  const LLMChatCard({super.key});

  @override
  State<LLMChatCard> createState() => _LLMChatCardState();
}

class _LLMChatCardState extends State<LLMChatCard> {
  final LLMService _llmService = ApiLLMService(llmApi: llmApi);
  late ChatSession _chatSession;
  bool _showSettings = false;
  bool _showPrompts = false; // Toggle for prompt selector visibility
  bool _isLoading = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _chatSession = ChatSession();

    // Initialize by loading available models
    _loadModels();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Load available models from the API
  Future<void> _loadModels() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final models = await _llmService.getAvailableModels();
      print('Available models: $models');

      if (mounted) {
        setState(() {
          _chatSession.availableModels = models;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackbar('Failed to load models: ${e.toString()}');
      }
    }
  }

  /// Send a user message and get response from the LLM API
  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    // Add user message to the chat
    _chatSession.addUserMessage(message);

    // Start generating indicator for response
    _chatSession.startAssistantMessage();

    // Scroll to the bottom
    _scrollToBottom();

    try {
      // Send the message to the API
      final response = await _llmService.sendChatCompletion(
        messages: _chatSession.toApiMessages(),
        modelId: _chatSession.selectedModelId,
        temperature: _chatSession.temperature,
      );

      if (!mounted) return;

      if (response != null) {
        final content = response.message.content;
        _chatSession.updateLastAssistantMessage(content);
      } else {
        _chatSession.addErrorMessage('Failed to get response from API');
      }
    } catch (e) {
      if (mounted) {
        _chatSession.addErrorMessage('Error: ${e.toString()}');
      }
    } finally {
      // Complete the assistant message generation indicator
      if (mounted) {
        _chatSession.completeLastAssistantMessage();
        // Scroll to bottom after response
        _scrollToBottom();
      }
    }
  }

  /// Scroll the chat list to the bottom
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Show an error message in a snackbar
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  /// Build the header with title and settings toggle
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Card title
          Icon(
            Icons.chat,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            'LLM Chat',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),

          // Prompt templates toggle
          IconButton(
            icon: Icon(
              _showPrompts ? Icons.psychology_outlined : Icons.psychology,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _showPrompts = !_showPrompts;
              });
            },
            tooltip: _showPrompts ? 'Hide prompts' : 'Show prompts',
          ),

          // Settings toggle
          IconButton(
            icon: Icon(
              _showSettings ? Icons.settings_outlined : Icons.settings,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _showSettings = !_showSettings;
              });
            },
            tooltip: _showSettings ? 'Hide settings' : 'Show settings',
          ),

          // Clear conversation button
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: _chatSession.messages.isEmpty
                ? null
                : () {
                    setState(() {
                      _chatSession.clearMessages();
                    });
                  },
            tooltip: 'Clear conversation',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _chatSession,
      child: Consumer<ChatSession>(
        builder: (context, chatSession, _) {
          return Card(
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            elevation: 1,
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 500, // Fixed height to prevent unbounded height error
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Set to min to avoid flex issues
                children: [
                  // Header
                  _buildHeader(context),

                  // Divider
                  const Divider(height: 1),

                  // Use Expanded to make the Stack fill the remaining space
                  Expanded(
                    child: Stack(
                      children: [
                        // Chat messages area (base layer)
                        Positioned.fill(
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _buildChatMessagesArea(chatSession),
                        ),

                        // Optional prompt selector panel (overlay)
                        if (_showPrompts)
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Material(
                              elevation: 2,
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 200),
                                child: PromptSelector(
                                  prompts: chatSession.availablePrompts,
                                  selectedPrompt: chatSession.selectedPrompt,
                                  onPromptSelected: (prompt) {
                                    chatSession.selectedPrompt = prompt;
                                  },
                                  onApplyPrompt: () {
                                    chatSession.applySelectedPrompt();
                                    // Show a confirmation
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Applied prompt: ${chatSession.selectedPrompt?.name}',
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  enabled: !chatSession.isGenerating,
                                ),
                              ),
                            ),
                          ),

                        // Optional settings panel (overlay)
                        if (_showSettings)
                          Positioned(
                            top: _showPrompts ? null : 0,
                            left: 0,
                            right: 0,
                            child: Material(
                              elevation: 2,
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 200),
                                child: ChatSettingsPanel(
                                  availableModels: chatSession.availableModels,
                                  selectedModelId: chatSession.selectedModelId,
                                  temperature: chatSession.temperature,
                                  onModelChanged: (modelId) {
                                    chatSession.selectedModelId = modelId;
                                  },
                                  onTemperatureChanged: (value) {
                                    chatSession.temperature = value;
                                  },
                                  enabled: !chatSession.isGenerating,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Input area
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChatInputField(
                      onSubmit: _sendMessage,
                      enabled: !chatSession.isGenerating,
                      placeholder: chatSession.isGenerating
                          ? 'Waiting for response...'
                          : 'Type a message...',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Build the chat messages scrollable area
  Widget _buildChatMessagesArea(ChatSession chatSession) {
    final messages = chatSession.messages;

    return messages.isEmpty
        ? _buildEmptyChatPlaceholder()
        : ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return ChatMessageBubble(
                message: messages[index],
              );
            },
          );
  }

  /// Build placeholder for empty chat
  Widget _buildEmptyChatPlaceholder() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Make sure to use MainAxisSize.min
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Start a conversation',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Type a message below to chat with an AI assistant',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
