import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_manager.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardManager = context
        .watch<CardManager>(); // Access layout mode if needed for styling
    final defaultMargin = cardManager.layoutMode == CardLayoutMode.dualColumn
        ? const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 0) // Smaller horizontal margin for dual column
        : const EdgeInsets.all(8);

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
              trailingActions != null)
            Container(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                children: [
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

          // Content area - Ensure content padding is present
          content,

          // Footer actions
          if (footerActions != null)
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
