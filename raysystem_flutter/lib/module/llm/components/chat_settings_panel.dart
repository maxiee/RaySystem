import 'package:flutter/material.dart';
import 'package:openapi/openapi.dart';

/// A panel for configuring chat settings like model selection and parameters
class ChatSettingsPanel extends StatelessWidget {
  /// Available LLM models to select from
  final List<ModelInfo> availableModels;

  /// Currently selected model ID
  final String? selectedModelId;

  /// Current temperature value (0.0-1.0)
  final double temperature;

  /// Callback when model selection changes
  final Function(String?) onModelChanged;

  /// Callback when temperature changes
  final Function(double) onTemperatureChanged;

  /// Whether settings can be changed (disabled during generation)
  final bool enabled;

  const ChatSettingsPanel({
    super.key,
    required this.availableModels,
    this.selectedModelId,
    this.temperature = 0.7,
    required this.onModelChanged,
    required this.onTemperatureChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Chat Settings',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Model selection
          _buildModelSelection(context),
          const SizedBox(height: 16),

          // Temperature slider
          _buildTemperatureSlider(context),
        ],
      ),
    );
  }

  /// Build the model selection dropdown
  Widget _buildModelSelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.smart_toy, size: 16),
            const SizedBox(width: 8),
            Text(
              'Model',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String?>(
          value: selectedModelId,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            isDense: true,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant,
          ),
          items: [
            // Auto option (use server default)
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('Default model (Auto)'),
            ),
            // Divider
            const DropdownMenuItem<String?>(
              enabled: false,
              child: Divider(),
            ),
            // Available models from API
            ...availableModels.map((model) {
              return DropdownMenuItem<String?>(
                value: model.name,
                child: Text(
                  model.displayName,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                  ),
                ),
              );
            }),
          ],
          onChanged: enabled ? onModelChanged : null,
        ),
      ],
    );
  }

  /// Build the temperature slider
  Widget _buildTemperatureSlider(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.thermostat, size: 16),
            const SizedBox(width: 8),
            Text(
              'Temperature: ${temperature.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Spacer(),
            Tooltip(
              message:
                  'Controls randomness: Higher values produce more creative results',
              triggerMode: TooltipTriggerMode.tap,
              showDuration: const Duration(seconds: 5),
              child: const Icon(Icons.info_outline, size: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Precise', style: TextStyle(fontSize: 12)),
            Expanded(
              child: Slider(
                value: temperature,
                min: 0.0,
                max: 1.0,
                divisions: 10,
                label: temperature.toStringAsFixed(1),
                onChanged: enabled ? onTemperatureChanged : null,
              ),
            ),
            const Text('Creative', style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
