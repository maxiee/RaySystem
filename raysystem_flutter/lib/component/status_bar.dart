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

    final valueStyle = TextStyle(
      color: isDark ? theme.colorScheme.primary : theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    Widget buildValueWithUnit(String value, String unit) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            child: Text(value, style: valueStyle),
          ),
          Text(unit, style: valueStyle.copyWith(fontSize: 8)),
        ],
      );
    }

    Widget buildMetricPair(String topValue, String bottomValue) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildValueWithUnit(topValue, '%'),
          buildValueWithUnit(bottomValue, '%'),
        ],
      );
    }

    Widget buildSpeedPair(String upValue, String downValue, String unit) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('↑', style: TextStyle(fontSize: 8)),
              buildValueWithUnit(upValue, unit),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('↓', style: TextStyle(fontSize: 8)),
              buildValueWithUnit(downValue, unit),
            ],
          ),
        ],
      );
    }

    return Wrap(
      spacing: 4,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // CPU and Memory
        buildMetricPair(
          'CPU ${metrics.cpuPercent.toStringAsFixed(1)}',
          'MEM ${metrics.memory.percent.toStringAsFixed(1)}',
        ),
        Text('📡'),
        // Network
        buildSpeedPair(
          metrics.network.uploadSpeedMb.toStringAsFixed(1),
          metrics.network.downloadSpeedMb.toStringAsFixed(1),
          'MB/s',
        ),
        Text('💿'),
        // Disk
        if (metrics.disks.isNotEmpty)
          buildSpeedPair(
            metrics.disks.first.writeSpeedMb.toStringAsFixed(1),
            metrics.disks.first.readSpeedMb.toStringAsFixed(1),
            'MB/s',
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                Row(
                    children:
                        left.map((w) => StatusBarItem(child: w)).toList()),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        center.map((w) => StatusBarItem(child: w)).toList(),
                  ),
                ),
                Row(
                    children:
                        right.map((w) => StatusBarItem(child: w)).toList()),
              ],
            ),
          ),
          Container(
            height: 32, // 增加高度以适应垂直布局
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
