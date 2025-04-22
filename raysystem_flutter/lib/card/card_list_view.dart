import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_manager.dart';

class CardListView extends StatelessWidget {
  const CardListView({super.key});

  // Helper to build a single list view column
  Widget _buildColumn(
      BuildContext context, List<Widget> cards, int columnIndex, bool isActive,
      {bool showBorder = false}) {
    final cardManager = context.read<CardManager>();
    final theme = Theme.of(context);
    final activeBorderColor = theme.colorScheme.primary.withOpacity(0.6);

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
        child: ListView.builder(
          addAutomaticKeepAlives: true,
          itemCount: cards.length,
          itemBuilder: (context, index) {
            final verticalPadding = showBorder ? 2.0 : 2.0;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: verticalPadding),
              child: KeepAliveWrapper(child: cards[index]),
            );
          },
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
