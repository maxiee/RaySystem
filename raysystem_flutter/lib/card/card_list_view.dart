import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_manager.dart';

class CardListView extends StatelessWidget {
  const CardListView({super.key});

  // Helper to build a single list view column
  Widget _buildColumn(BuildContext context, List<Widget> cards, int columnIndex,
      bool isActive) {
    final cardManager = context.read<CardManager>(); // Use read for callbacks
    final theme = Theme.of(context);
    final activeBorderColor = theme.colorScheme.primary.withOpacity(0.6);

    return GestureDetector(
      onTap: () {
        // Set this column as active when tapped
        cardManager.setActiveColumn(columnIndex);
      },
      child: Container(
        // Add a border if this column is active in dual-column mode
        decoration: BoxDecoration(
          border:
              isActive && cardManager.layoutMode == CardLayoutMode.dualColumn
                  ? Border.all(color: activeBorderColor, width: 2.0)
                  : null,
          borderRadius:
              isActive && cardManager.layoutMode == CardLayoutMode.dualColumn
                  ? BorderRadius.circular(
                      4.0) // Optional: rounded corners for the border
                  : null,
        ),
        padding: isActive && cardManager.layoutMode == CardLayoutMode.dualColumn
            ? const EdgeInsets.all(2.0) // Padding inside the border
            : EdgeInsets.zero,
        child: ListView.builder(
          addAutomaticKeepAlives: true, // Keep state
          itemCount: cards.length,
          itemBuilder: (context, index) {
            // Use a smaller vertical padding for dual column potentially
            final verticalPadding =
                cardManager.layoutMode == CardLayoutMode.dualColumn ? 4.0 : 8.0;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPadding),
              // KeepAliveWrapper is still useful
              child: KeepAliveWrapper(
                child: cards[index],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch for changes in CardManager (layout mode, active column, card lists)
    final cardManager = context.watch<CardManager>();

    if (cardManager.layoutMode == CardLayoutMode.singleColumn) {
      // Single Column Layout: Display only the left list
      return _buildColumn(context, cardManager.leftCards, 0,
          true); // Always active in single mode
    } else {
      // Dual Column Layout: Display left and right lists side-by-side
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildColumn(
              context,
              cardManager.leftCards,
              0, // Column index 0
              cardManager.activeColumnIndex == 0, // Is active?
            ),
          ),
          const SizedBox(width: 8), // Spacer between columns
          Expanded(
            child: _buildColumn(
              context,
              cardManager.rightCards,
              1, // Column index 1
              cardManager.activeColumnIndex == 1, // Is active?
            ),
          ),
        ],
      );
    }
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
