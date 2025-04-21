import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_manager.dart';
import 'package:raysystem_flutter/component/status_bar/items/always_on_top.dart';
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
    // Watch CardManager for layout mode changes
    final cardManager = context.watch<CardManager>();

    // 多列切换按钮（横向排布 1/2/3/4），自适应缩放
    Widget layoutToggleButtons = Tooltip(
      message: '切换卡片列数',
      child: FittedBox(
        fit: BoxFit.contain,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(4, (i) {
            final colNum = i + 1;
            final isActive = cardManager.columnCount == colNum;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: TextButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  backgroundColor: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  foregroundColor: isActive
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                  minimumSize: const Size(24, 16),
                  maximumSize: const Size(32, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.dividerColor,
                      width: isActive ? 2 : 1,
                    ),
                  ),
                  elevation: isActive ? 2 : 0,
                ),
                onPressed: () => cardManager.setColumnCount(colNum),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('$colNum',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }),
        ),
      ),
    );

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
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Row(children: left.map((w) => StatusBarItem(child: w)).toList()),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: center.map((w) => StatusBarItem(child: w)).toList(),
              ),
            ),
            Row(children: [
              StatusBarItem(child: _buildMetricsSection(context)),
              // Add the layout toggle button here
              StatusBarItem(child: layoutToggleButtons),
              StatusBarItem(child: AlwaysOnTopItem()),
              ...right.map((w) => StatusBarItem(child: w))
            ]),
          ],
        ),
      ),
    );
  }
}
