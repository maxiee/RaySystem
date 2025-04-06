import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:raysystem_flutter/module/editor/blocks/code/plugin.dart';

/// A custom AppFlowy editor component that encapsulates the editor configuration
/// This component handles the initialization and customization of the AppFlowyEditor
class CustomAppFlowyEditor extends StatelessWidget {
  /// The editor state for managing the document
  final EditorState editorState;

  /// Controller for scrolling in the editor
  final EditorScrollController? editorScrollController;

  /// Whether the editor is editable
  final bool editable;

  /// Whether the editor should shrink to fit its content
  final bool shrinkWrap;

  const CustomAppFlowyEditor({
    super.key,
    required this.editorState,
    this.editorScrollController,
    this.editable = true,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingToolbar(
      items: [
        paragraphItem,
        ...headingItems,
        ...markdownFormatItems,
        quoteItem,
        codeBlockToolbarItem,
        bulletedListItem,
        numberedListItem,
        linkItem,
        buildTextColorItem(),
        buildHighlightColorItem(),
        ...textDirectionItems,
        ...alignmentItems
      ],
      textDirection: TextDirection.ltr,
      editorState: editorState,
      editorScrollController: editorScrollController ??
          EditorScrollController(editorState: editorState),
      child: AppFlowyEditor(
        editorState: editorState,
        editorScrollController: editorScrollController,
        characterShortcutEvents: [
          ...codeBlockCharacterEvents,
          customSlashCommand([
            ...standardSelectionMenuItems,
            codeBlockItem('Code Block', Icons.code),
          ]),
          ...standardCharacterShortcutEvents.where(
            (event) {
              if (event == slashCommand) {
                return false; // remove standard slash command
              }
              return true;
            },
          ).toList(),
        ],
        commandShortcutEvents: [
          ...codeBlockCommands(),
          ...standardCommandShortcutEvents.where(
            (event) => event != pasteCommand, // remove standard paste command
          )
        ],
        blockComponentBuilders: {
          ...standardBlockComponentBuilderMap,
          CodeBlockKeys.type: CodeBlockComponentBuilder(
              configuration: BlockComponentConfiguration(
                textStyle: (Node node, {TextSpan? textSpan}) => const TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              styleBuilder: () => CodeBlockStyle(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[200]!
                            : Colors.grey[800]!,
                    foregroundColor:
                        Theme.of(context).brightness == Brightness.light
                            ? Colors.blue
                            : Colors.blue[800]!,
                  ),
              actions: CodeBlockActions(
                onCopy: (code) => Clipboard.setData(ClipboardData(text: code)),
              )),
        },
        editable: editable,
        shrinkWrap: shrinkWrap,
        // 自定义样式设置，使用 LXGW WenKai Mono 字体
        editorStyle: EditorStyle.desktop(
          padding: EdgeInsets.zero,
          textStyleConfiguration: TextStyleConfiguration(
            text: TextStyle(
              fontFamily: 'LXGW WenKai',
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper class for editor operations
class EditorHelper {
  /// Create an empty editor state
  static EditorState createEmptyEditor() {
    return EditorState.blank();
  }

  /// Create an editor state from JSON content
  static EditorState? createEditorFromJson(String? contentJson) {
    if (contentJson == null || contentJson.isEmpty) {
      return EditorState.blank();
    }

    try {
      final document = Document.fromJson({'document': jsonDecode(contentJson)});
      return EditorState(document: document);
    } catch (e) {
      debugPrint('Error parsing content JSON: $e');
      return EditorState.blank();
    }
  }

  /// Serialize editor content to JSON string
  static String serializeEditorContent(EditorState editorState) {
    final contentJson = editorState.document.toJson();
    return jsonEncode(contentJson['document']);
  }
}
