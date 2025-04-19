import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../api/api.dart';
import '../api/llm_service.dart';
import '../models/chat_session.dart';
import '../models/chat_session_model.dart';
import 'package:openapi/openapi.dart'; // Import for ChatSessionUpdate
import 'chat_header.dart';
import 'chat_input_field.dart';
import 'chat_messages_area.dart';
import 'chat_settings_panel.dart';
import 'prompt_selector.dart';
import 'chat_sessions_sidebar.dart';

/// A card widget that displays an LLM chat interface
class LLMChatCard extends StatefulWidget {
  const LLMChatCard({super.key});

  @override
  State<LLMChatCard> createState() => _LLMChatCardState();
}

class _LLMChatCardState extends State<LLMChatCard> {
  final LLMService _llmService = ApiLLMService(llmApi: llmApi);
  bool _showSettings = false;
  bool _showPrompts = false; // Toggle for prompt selector visibility
  bool _showSessionsSidebar = false; // Toggle for sessions sidebar visibility
  bool _isLoading = true;
  String? _activeSessionTitle; // 当前会话标题
  int? _activeSessionId; // 当前会话ID

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // 初始化时通过 Provider 获取 ChatSession 并加载模型
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatSession = Provider.of<ChatSession>(context, listen: false);
      _loadModels(chatSession);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Load available models from the API
  Future<void> _loadModels(ChatSession chatSession) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final models = await _llmService.getAvailableModels();
      debugPrint('Available models: $models');

      if (mounted) {
        setState(() {
          chatSession.availableModels = models;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackbar('Failed to load models: \\${e.toString()}');
      }
    }
  }

  /// Send a user message and get response from the LLM API
  Future<void> _sendMessage(String message) async {
    final chatSession = Provider.of<ChatSession>(context, listen: false);
    if (message.trim().isEmpty) return;

    // Add user message to the chat
    chatSession.addUserMessage(message);

    // Start generating indicator for response
    chatSession.startAssistantMessage();

    // Scroll to the bottom
    _scrollToBottom();

    try {
      // Create a cancel token for the streaming request
      final cancelToken = chatSession.getOrCreateCancelToken();

      // Get the stream from the API
      final stream = await _llmService.sendStreamingChatCompletion(
        messages: chatSession.toApiMessages(),
        modelId: chatSession.selectedModelId,
        temperature: chatSession.temperature,
        cancelToken: cancelToken,
      );

      // Track the accumulating message content
      String fullContent = '';

      // Process the streaming response
      await for (final chunk in stream) {
        if (!mounted) {
          chatSession.cancelStreamingRequest();
          break;
        }

        // 检查是否为有效的新内容
        if (chunk.isNotEmpty) {
          // Add the new chunk to our accumulated content
          fullContent += chunk;

          // Update with the full content accumulated so far
          chatSession.updateLastAssistantMessage(fullContent);

          // Scroll to show new content
          _scrollToBottom();
        }
      }
    } catch (e) {
      if (mounted) {
        if (e is DioException && e.type == DioExceptionType.cancel) {
          // User cancelled the request, so we'll just show what we have so far
          debugPrint('Stream cancelled by user');
        } else {
          chatSession.addErrorMessage('Error: \\${e.toString()}');
        }
      }
    } finally {
      // Complete the assistant message generation indicator
      // WITHOUT updating the content again, just mark as not generating
      if (mounted) {
        chatSession.completeLastAssistantMessage(updateContent: false);
        // Scroll to bottom after response
        _scrollToBottom();

        // Auto-save the chat session after successful response
        if (_activeSessionId != null) {
          _autoSaveCurrentSession();
        }
      }
    }
  }

  /// Automatically save the current chat session after a successful response
  Future<void> _autoSaveCurrentSession() async {
    // Only attempt to save if we have an active session ID
    if (_activeSessionId == null) return;

    final chatSession = Provider.of<ChatSession>(context, listen: false);
    if (chatSession.messages.isEmpty) return; // No messages to save

    try {
      // Prepare the current session's content JSON
      final contentJson = jsonEncode(chatSession.messages
          .map((msg) => {
                'role': msg.role,
                'content': msg.content,
                'timestamp': msg.timestamp.toIso8601String(),
              })
          .toList());

      // Create update request body
      final request = ChatSessionUpdate((b) {
        b.contentJson = contentJson;
      });

      // Send API request
      final response =
          await llmApi.updateChatSessionLlmChatSessionsSessionIdPut(
        sessionId: _activeSessionId!,
        chatSessionUpdate: request,
      );

      if (response.data != null) {
        // Show subtle auto-save indication (optional)
        debugPrint('Auto-saved chat session: ${_activeSessionTitle}');
      }
    } catch (e) {
      debugPrint('Auto-save failed: ${e.toString()}');
      // Silent failure for auto-save to avoid disrupting user experience
    }
  }

  /// Scroll the chat list to the bottom
  void _scrollToBottom() {
    // Only schedule scroll if the widget is still mounted
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        // Use a shorter duration for smoother streaming appearance
        final scrollDuration = _showPrompts
            ? const Duration(milliseconds: 100) // Faster during generation
            : const Duration(milliseconds: 300); // Normal speed otherwise

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: scrollDuration,
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

  // Using ChatHeader widget instead of _buildHeader method

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatSession>(
      builder: (context, chatSession, _) {
        return SizedBox(
          height: 500, // Fixed height to prevent unbounded height error
          child: Row(
            children: [
              // Chat Session Management Sidebar
              if (_showSessionsSidebar)
                ChatSessionsSidebar(
                  llmApi: llmApi,
                  onSessionSelected: _handleSessionSelected,
                  onSidebarToggle: (show) =>
                      setState(() => _showSessionsSidebar = show),
                  isOpen: _showSessionsSidebar,
                  currentChatSession: chatSession,
                )
              else
                // Just the toggle handle when sidebar is closed
                InkWell(
                  onTap: () => setState(() => _showSessionsSidebar = true),
                  child: Container(
                    width: 24,
                    decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                              color: Theme.of(context).dividerColor)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),

              // Main Chat Area
              Expanded(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Set to min to avoid flex issues
                  children: [
                    // Header
                    ChatHeader(
                      chatSession: chatSession,
                      sessionTitle: _activeSessionTitle,
                      showSessionsSidebar: _showSessionsSidebar,
                      showPrompts: _showPrompts,
                      showSettings: _showSettings,
                      onToggleSessionsSidebar: () {
                        setState(() {
                          _showSessionsSidebar = true;
                        });
                      },
                      onTogglePrompts: () {
                        setState(() {
                          _showPrompts = !_showPrompts;
                        });
                      },
                      onToggleSettings: () {
                        setState(() {
                          _showSettings = !_showSettings;
                        });
                      },
                      onClearChat: chatSession.messages.isEmpty
                          ? null
                          : () {
                              setState(() {
                                chatSession.clearMessages();
                                _activeSessionTitle = null;
                              });
                            },
                    ),

                    // Divider
                    const Divider(height: 1),

                    // Use Expanded to make the Stack fill the remaining space
                    Expanded(
                      child: Stack(
                        children: [
                          // Chat messages area (base layer)
                          Positioned.fill(
                            child: _isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ChatMessagesArea(
                                    chatSession: chatSession,
                                    scrollController: _scrollController,
                                  ),
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                    availableModels:
                                        chatSession.availableModels,
                                    selectedModelId:
                                        chatSession.selectedModelId,
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
            ],
          ),
        );
      },
    );
  }

  // Methods _buildChatMessagesArea and _buildEmptyChatPlaceholder have been refactored as separate widgets

  /// Handle when a chat session is selected from the sidebar
  void _handleSessionSelected(ChatSessionModel sessionModel) {
    final chatSession = Provider.of<ChatSession>(context, listen: false);
    setState(() {
      _isLoading = false;
      _activeSessionTitle = sessionModel.title;
      _activeSessionId = sessionModel.id; // Store the session ID
    });

    // Update the UI title to reflect the selected session
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loaded chat session: ${sessionModel.title}'),
        duration: const Duration(seconds: 2),
      ),
    );

    // Load the session content
    chatSession.loadFromSessionModel(sessionModel);

    // Auto-scroll to the bottom after loading the session
    _scrollToBottom();
  }
}
