import 'package:flutter/material.dart';
import '../models/chat_prompt.dart';

/// A widget that allows selecting from preset prompts/roles
class PromptSelector extends StatelessWidget {
  /// List of available prompts
  final List<ChatPrompt> prompts;

  /// The currently selected prompt, if any
  final ChatPrompt? selectedPrompt;

  /// Callback when a prompt is selected
  final void Function(ChatPrompt) onPromptSelected;

  /// Callback when user wants to apply the prompt
  final VoidCallback onApplyPrompt;

  /// Whether the selector is enabled
  final bool enabled;

  const PromptSelector({
    super.key,
    required this.prompts,
    this.selectedPrompt,
    required this.onPromptSelected,
    required this.onApplyPrompt,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
            child: Row(
              children: [
                const Text(
                  'Prompt Template',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message:
                      'Select a preset prompt to define the AI assistant\'s behavior',
                  child: Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0, // Horizontal space between chips
              runSpacing: 4.0, // Vertical space between lines
              children: [
                // Prompt selection chips
                ...prompts.map((prompt) => ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (prompt.iconName != null) ...[
                            Icon(
                              _getIconData(prompt.iconName!),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(prompt.name),
                        ],
                      ),
                      selected: selectedPrompt?.id == prompt.id,
                      onSelected: enabled
                          ? (selected) {
                              if (selected) {
                                onPromptSelected(prompt);
                              }
                            }
                          : null,
                      tooltip: prompt.description,
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Apply Prompt'),
                onPressed:
                    (enabled && selectedPrompt != null) ? onApplyPrompt : null,
                style: ElevatedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          ),

          // Display selected prompt description
          if (selectedPrompt != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedPrompt!.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedPrompt!.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Convert a string icon name to an IconData
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'assistant':
        return Icons.smart_toy;
      case 'code':
        return Icons.code;
      case 'school':
        return Icons.school;
      case 'create':
        return Icons.create;
      default:
        return Icons.chat;
    }
  }
}
