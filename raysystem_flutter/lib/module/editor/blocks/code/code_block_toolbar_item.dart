import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:raysystem_flutter/module/editor/blocks/code/code_block_block_component.dart';

/// The toolbar item for the Code Block.
///
/// This toolbar item allows users to convert text to a code block or convert a code block back to normal text.
/// It's designed to be used with the AppFlowyEditor toolbar.
class CodeBlockToolbarItem extends ToolbarItem {
  CodeBlockToolbarItem()
      : super(
          id: 'editor.code_block',
          group: 1,
          isActive: onlyShowInSingleSelectionAndTextType,
          builder: (
            context,
            editorState,
            highlightColor,
            iconColor,
            tooltipBuilder,
          ) {
            final selection = editorState.selection!;
            final node = editorState.getNodeAtPath(selection.start.path)!;
            final isHighlight = node.type == CodeBlockKeys.type;
            final delta = (node.delta ?? Delta()).toJson();

            final child = SVGIconItemWidget(
              iconName: 'toolbar/code',
              isHighlight: isHighlight,
              highlightColor: highlightColor,
              iconColor: iconColor,
              onPressed: () => editorState.formatNode(
                selection,
                (node) => node.copyWith(
                  type: isHighlight
                      ? ParagraphBlockKeys.type
                      : CodeBlockKeys.type,
                  attributes: {
                    if (!isHighlight) CodeBlockKeys.language: 'auto',
                    blockComponentBackgroundColor:
                        node.attributes[blockComponentBackgroundColor],
                    blockComponentTextDirection:
                        node.attributes[blockComponentTextDirection],
                    blockComponentDelta: delta,
                  },
                ),
              ),
            );

            if (tooltipBuilder != null) {
              return tooltipBuilder(
                context,
                'editor.code_block',
                'Code Block',
                child,
              );
            }

            return child;
          },
        );
}

/// A toolbar item to be used in a toolbar list
final ToolbarItem codeBlockToolbarItem = CodeBlockToolbarItem();
