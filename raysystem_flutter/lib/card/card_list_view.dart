import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_manager.dart';

class CardListView extends StatelessWidget {
  const CardListView({super.key});

  // Helper to build a single column
  Widget _buildColumn(
      BuildContext context, List<Widget> cards, int columnIndex, bool isActive,
      {bool showBorder = false}) {
    final cardManager = context.read<CardManager>();
    final theme = Theme.of(context);
    final activeBorderColor = theme.colorScheme.primary.withOpacity(0.6);

    // Build the list of children for the Column, wrapping adaptive cards in Expanded
    List<Widget> columnChildren = [];
    for (final cardWidget in cards) {
      // The cardWidget is expected to be the RepaintBoundary wrapping RayCard
      final cardKey = cardWidget.key;
      if (cardKey == null) {
        // Should not happen if added via CardManager.addCard
        columnChildren.add(cardWidget);
        continue;
      }

      final isMinimized = cardManager.isCardMinimized(cardKey);

      if (isMinimized) {
        // Minimized cards just take their minimal space
        columnChildren.add(Flexible(
          fit: FlexFit.tight,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: showBorder ? 1.0 : 1.0), // Minimal padding
            child: cardWidget,
          ),
        ));
      } else {
        // Maximized cards
        final isAdaptive = cardManager.isCardAdaptive(cardKey);
        if (isAdaptive) {
          // Adaptive cards expand
          final flex = cardManager.getCardFlexFactor(cardKey);
          columnChildren.add(
            Expanded(
                flex: flex,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: showBorder ? 1.0 : 1.0), // Minimal padding
                  child: cardWidget,
                )),
          );
        } else {
          // Fixed-height cards take their required space
          columnChildren.add(Padding(
            padding: EdgeInsets.symmetric(
                vertical: showBorder ? 1.0 : 1.0), // Minimal padding
            child: cardWidget,
          ));
        }
      }
    }

    return GestureDetector(
      onTap: () {
        cardManager.setActiveColumn(columnIndex);
      },
      child: Container(
        decoration: BoxDecoration(
          border: isActive && showBorder
              ? Border.all(color: activeBorderColor, width: 2.0)
              : Border.all(
                  color: theme.colorScheme.onSurface.withOpacity(0.2),
                  width: 1.0),
          borderRadius:
              isActive && showBorder ? BorderRadius.circular(4.0) : null,
        ),
        padding: isActive && showBorder
            ? const EdgeInsets.all(2.0)
            : EdgeInsets.zero,
        // Replace ListView.builder with a Column
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Stretch cards horizontally
          children: columnChildren,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardManager = context.watch<CardManager>();
    final columns = cardManager.columns;
    final active = cardManager.activeColumnIndex;
    final colCount = cardManager.columnCount;
    // 多列布局
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align columns to the top
      children: List.generate(
        colCount,
        (i) => Expanded(
          child: Padding(
            padding: i == 0 ? EdgeInsets.zero : const EdgeInsets.only(left: 2),
            child: _buildColumn(
              context,
              columns[i],
              i,
              active == i,
              showBorder: colCount > 1,
            ),
          ),
        ),
      ),
    );
  }
}
