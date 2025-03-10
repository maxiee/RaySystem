import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_manager.dart';

class CardListView extends StatelessWidget {
  const CardListView({super.key});

  @override
  Widget build(BuildContext context) {
    final cardManager = context.watch<CardManager>();

    return ListView.builder(
      // 设置为 true 以确保 item 在滑出屏幕时不会被回收
      addAutomaticKeepAlives: true,
      itemCount: cardManager.cards.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          // 使用 KeepAliveWrapper 包装卡片
          child: KeepAliveWrapper(
            child: RayCard(
              content: cardManager.cards[index],
            ),
          ),
        );
      },
    );
  }
}

/// 用于保持卡片在滑出屏幕时不被销毁的包装器
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    // 必须调用 super.build
    super.build(context);
    return widget.child;
  }

  @override
  // 返回 true 以保持此组件活着
  bool get wantKeepAlive => true;
}

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

    return Card(
      elevation: elevation ?? 1,
      margin: margin ?? const EdgeInsets.all(8),
      color: color ?? theme.cardColor,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title bar with leading and trailing actions
            if (title != null ||
                leadingActions != null ||
                trailingActions != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    // Left section - leading actions
                    if (leadingActions != null) ...[
                      ...leadingActions!,
                      const SizedBox(width: 8),
                    ],

                    // Middle section - title
                    if (title != null) Expanded(child: Center(child: title!)),

                    // Right section - trailing actions
                    if (trailingActions != null) ...[
                      if (title != null) const SizedBox(width: 8),
                      ...trailingActions!,
                    ],
                  ],
                ),
              ),

            // Content area
            content,

            // Footer actions
            if (footerActions != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: footerActions!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Removed EvaCardClipper and EvaCardDecorationPainter classes as they are no longer needed
