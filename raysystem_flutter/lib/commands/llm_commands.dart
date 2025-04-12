import 'package:flutter/material.dart';
import 'package:raysystem_flutter/commands/command.dart';
import 'package:raysystem_flutter/module/llm/components/llm_chat_card.dart';

/// Command for LLM chat functionality
final Command llmCommands = Command(
  command: 'llm-app',
  title: '大模型',
  icon: Icons.smart_toy,
  subCommands: [
    Command(
      command: 'llm-chat',
      title: 'AI助手',
      icon: Icons.chat,
      callback: (context, cardManager) async {
        cardManager.addCard(
          const LLMChatCard(),
        );
      },
    ),
  ],
);
