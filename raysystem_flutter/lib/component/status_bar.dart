import 'package:flutter/material.dart';

class StatusBarItem {
  final Widget child;
  final double? flex;

  StatusBarItem({required this.child, this.flex});
}

class StatusBar extends StatelessWidget {
  final List<StatusBarItem>? left;
  final List<StatusBarItem>? center;
  final List<StatusBarItem>? right;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;
  final EdgeInsets padding;

  const StatusBar({
    super.key,
    this.left,
    this.center,
    this.right,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 24.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
  });

  Widget _buildSection(List<StatusBarItem>? items, Color textColor) {
    if (items == null || items.isEmpty) return const SizedBox();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items.map((item) {
        return Flexible(
          flex: (item.flex ?? 1.0).toInt(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontFamily: 'monospace',
              ),
              child: item.child,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBackgroundColor = backgroundColor ??
        (isDark
            ? theme.colorScheme.surface.withOpacity(0.8)
            : theme.colorScheme.primaryContainer
                .withOpacity(0.95)); // 使用更深的绿色且略微透明

    final effectiveForegroundColor =
        foregroundColor ?? (isDark ? theme.colorScheme.primary : Colors.white);

    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? theme.colorScheme.primary.withOpacity(0.5)
                : theme.colorScheme.primary.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? theme.colorScheme.primary.withOpacity(0.2)
                : theme.colorScheme.primary.withOpacity(0.1),
            blurRadius: isDark ? 8 : 4,
            offset: Offset(0, isDark ? 2 : 1),
          )
        ],
      ),
      child: Row(
        children: [
          // Left section
          Expanded(
            flex: 2,
            child: _buildSection(left, effectiveForegroundColor),
          ),
          // Center section
          Expanded(
            flex: 1,
            child:
                Center(child: _buildSection(center, effectiveForegroundColor)),
          ),
          // Right section
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [_buildSection(right, effectiveForegroundColor)],
            ),
          ),
        ],
      ),
    );
  }
}
