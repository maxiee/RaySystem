import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/component/system_metrics_provider.dart';

class StatusBarItem extends StatelessWidget {
  final Widget child;
  const StatusBarItem({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: DefaultTextStyle(
        style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              fontFeatures: [const FontFeature.tabularFigures()],
            ) ??
            const TextStyle(fontSize: 11),
        child: child,
      ),
    );
  }
}

class StatusBar extends StatelessWidget {
  final List<Widget> left;
  final List<Widget> center;
  final List<Widget> right;

  const StatusBar({
    super.key,
    this.left = const [],
    this.center = const [],
    this.right = const [],
  });

  Widget _buildMetricsSection(BuildContext context) {
    final metrics = context.watch<SystemMetricsProvider>().metrics;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (metrics == null) return const SizedBox.shrink();

    // Style for metric values
    final valueStyle = TextStyle(
      color: isDark ? theme.colorScheme.primary : theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
      fontSize: 11,
    );

    return Wrap(
      spacing: 8,
      runSpacing: 2,
      children: [
        // CPU
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style.copyWith(fontSize: 11),
            children: [
              TextSpan(text: '🔲 CPU '),
              TextSpan(
                text: '${metrics.cpuPercent.toStringAsFixed(1)}%',
                style: valueStyle,
              ),
            ],
          ),
        ),
        // Memory
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style.copyWith(fontSize: 11),
            children: [
              TextSpan(text: '💾 MEM '),
              TextSpan(
                text: '${(metrics.memory.percent).toStringAsFixed(1)}% ',
                style: valueStyle,
              ),
              TextSpan(
                  text:
                      '(${metrics.memory.usedGb.toStringAsFixed(1)}/${metrics.memory.totalGb.toStringAsFixed(1)})'),
            ],
          ),
        ),
        // Network
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style.copyWith(fontSize: 11),
            children: [
              TextSpan(text: '📡 NET '),
              TextSpan(
                text:
                    '↑${metrics.network.uploadSpeedMb.toStringAsFixed(2)}MB/s ',
                style: valueStyle,
              ),
              TextSpan(
                text:
                    '↓${metrics.network.downloadSpeedMb.toStringAsFixed(2)}MB/s',
                style: valueStyle,
              ),
            ],
          ),
        ),
        // Disk
        if (metrics.disks.isNotEmpty) ...[
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style.copyWith(fontSize: 11),
              children: [
                TextSpan(text: '💿 DISK '),
                TextSpan(
                  text:
                      '↑${metrics.disks.first.writeSpeedMb.toStringAsFixed(2)}MB/s ',
                  style: valueStyle,
                ),
                TextSpan(
                  text:
                      '↓${metrics.disks.first.readSpeedMb.toStringAsFixed(2)}MB/s',
                  style: valueStyle,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // final metrics = context.watch<SystemMetricsProvider>().metrics;
    // print('Metrics: $metrics'); // 调试信息

    return Container(
      decoration: BoxDecoration(
        color:
            isDark ? theme.colorScheme.surface : theme.colorScheme.background,
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? theme.colorScheme.primary.withOpacity(0.3)
                : theme.colorScheme.primary.withOpacity(0.1),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 24,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                // Left section
                Row(
                    children:
                        left.map((w) => StatusBarItem(child: w)).toList()),
                // Center section
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        center.map((w) => StatusBarItem(child: w)).toList(),
                  ),
                ),
                // Right section with system metrics
                Row(
                    children:
                        right.map((w) => StatusBarItem(child: w)).toList()),
              ],
            ),
          ),
          // Second row for system metrics
          Container(
            height: 20,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatusBarItem(child: _buildMetricsSection(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
