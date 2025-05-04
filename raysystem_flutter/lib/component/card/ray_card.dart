import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_manager.dart';
import 'package:raysystem_flutter/component/widgets/mac_os_buttons.dart';

class RayCard extends StatelessWidget {
  // Properties for the three main sections
  final Widget? title;
  final List<Widget>? leadingActions;
  final List<Widget>? trailingActions;
  final Widget content;
  final List<Widget>? footerActions;

  // Other card properties
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;

  const RayCard({
    super.key,
    this.title,
    this.leadingActions,
    this.trailingActions,
    required this.content,
    this.footerActions,
    this.color,
    this.padding,
    this.margin,
    this.elevation,
  });

  // Helper method to check if this card is minimized
  bool _isCardMinimized(BuildContext context) {
    // Try to find the nearest parent key
    final Key? parentKey =
        context.findAncestorWidgetOfExactType<RepaintBoundary>()?.key;
    if (parentKey != null) {
      final cardManager = context.read<CardManager>();
      return cardManager.isCardMinimized(parentKey);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardManager = context.watch<CardManager>();
    // 动态 margin: 列数越多，横向 margin 越小
    EdgeInsetsGeometry defaultMargin;
    switch (cardManager.columnCount) {
      case 1:
        defaultMargin = const EdgeInsets.all(2);
        break;
      case 2:
        defaultMargin = const EdgeInsets.symmetric(horizontal: 4, vertical: 0);
        break;
      case 3:
        defaultMargin = const EdgeInsets.symmetric(horizontal: 2, vertical: 0);
        break;
      case 4:
        defaultMargin = const EdgeInsets.symmetric(horizontal: 1, vertical: 0);
        break;
      default:
        defaultMargin = const EdgeInsets.all(8);
    }

    // 获取父级 RepaintBoundary 的 key，用于识别卡片身份
    final Key? parentKey =
        context.findAncestorWidgetOfExactType<RepaintBoundary>()?.key;

    return Card(
      elevation: elevation ?? 1,
      margin: margin ?? defaultMargin,
      color: color ?? theme.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title bar with leading and trailing actions
          if (title != null ||
              leadingActions != null ||
              trailingActions != null ||
              parentKey != null)
            Container(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                children: [
                  // 内置 MacOS 按钮
                  if (parentKey != null) ...[
                    MacOSCloseButton(
                      onPressed: () => cardManager.removeCardByKey(parentKey),
                    ),
                    const SizedBox(width: 8),
                    MacOSMinimizeButton(
                      onPressed: () => cardManager.minimizeCard(parentKey),
                    ),
                    const SizedBox(width: 8),
                    MacOSMaximizeButton(
                      onPressed: () => cardManager.maximizeCard(parentKey),
                    ),
                    const SizedBox(width: 8),
                  ],
                  // 用户提供的额外 leading actions
                  if (leadingActions != null) ...[
                    ...leadingActions!,
                    const SizedBox(width: 8),
                  ],
                  if (title != null)
                    Expanded(
                      child: DefaultTextStyle(
                        style: theme.textTheme.titleSmall ?? TextStyle(),
                        textAlign: TextAlign.center,
                        child: title!,
                      ),
                    ),

                  // Spacer to push trailing actions right if no title but leading actions exist
                  if (title == null && leadingActions != null) Spacer(),
                  if (trailingActions != null) ...[
                    // Add spacer only if title or leading actions are present
                    if (title != null || leadingActions != null)
                      const SizedBox(width: 8),
                    ...trailingActions!,
                  ],
                ],
              ),
            ),

          // Content area - Only show if not minimized
          // We use Visibility instead of conditional rendering to maintain state
          // Expanded(
          //   child: Visibility(
          //     // Check if this card is minimized by finding its key and checking state
          //     visible: !_isCardMinimized(context),
          //     // Maintain state even when not visible
          //     maintainState: true,
          //     // Content
          //     child: content,
          //   ),
          // ),
          _isCardMinimized(context)
              ? const SizedBox.shrink()
              : Expanded(
                  child: content,
                ),

          // Footer actions - Only show if not minimized
          if (footerActions != null &&
              footerActions!.isNotEmpty &&
              !_isCardMinimized(context))
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(12, 0, 12, 8), // Padding for footer
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: footerActions!,
              ),
            ),
        ],
      ),
    );
  }
}
