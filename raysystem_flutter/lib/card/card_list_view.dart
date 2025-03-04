import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:raysystem_flutter/card/card_manager.dart';

class CardListView extends StatelessWidget {
  const CardListView({super.key});

  @override
  Widget build(BuildContext context) {
    final cardManager = context.watch<CardManager>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView.builder(
      itemCount: cardManager.cards.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: EvaMonitorCard(
            child: cardManager.cards[index],
          ),
        );
      },
    );
  }
}

class EvaMonitorCard extends StatelessWidget {
  final Widget child;

  const EvaMonitorCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? const Color(0xFFFF6600) : theme.primaryColor;
    final accentColor = isDark ? const Color(0xFF00FF00) : theme.primaryColor;

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2A) : theme.cardTheme.color,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipPath(
        clipper: EvaCardClipper(),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A2A) : theme.cardTheme.color,
            border: Border.all(
              color: primaryColor.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: EvaCardDecorationPainter(
                    primaryColor: primaryColor,
                    accentColor: accentColor,
                    isDark: isDark,
                  ),
                ),
              ),

              // 内容区域
              Container(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 状态指示器
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: accentColor,
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withOpacity(0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'MONITOR ACTIVE',
                          style: TextStyle(
                            fontSize: 10,
                            color: accentColor,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    child,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EvaCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    const cutSize = 24.0;
    const smallCut = 12.0;

    // 左上切角
    path.moveTo(0, cutSize);
    path.lineTo(0, h - smallCut);
    // 左下切角
    path.lineTo(smallCut, h);
    path.lineTo(w - cutSize, h);
    // 右下切角
    path.lineTo(w, h - cutSize);
    path.lineTo(w, smallCut);
    // 右上切角
    path.lineTo(w - smallCut, 0);
    path.lineTo(cutSize, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class EvaCardDecorationPainter extends CustomPainter {
  final Color primaryColor;
  final Color accentColor;
  final bool isDark;

  EvaCardDecorationPainter({
    required this.primaryColor,
    required this.accentColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    const cutSize = 24.0;
    const smallCut = 12.0;

    // 绘制装饰性边框
    final borderPaint = Paint()
      ..color = primaryColor.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final accentPaint = Paint()
      ..color = accentColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 左上角装饰
    canvas.drawLine(
      Offset(0, cutSize + 20),
      Offset(0, cutSize),
      borderPaint,
    );
    canvas.drawLine(
      Offset(0, cutSize),
      Offset(cutSize, 0),
      borderPaint,
    );
    canvas.drawLine(
      Offset(cutSize, 0),
      Offset(cutSize + 20, 0),
      borderPaint,
    );

    // 右下角装饰
    canvas.drawLine(
      Offset(w, h - cutSize - 20),
      Offset(w, h - cutSize),
      borderPaint,
    );
    canvas.drawLine(
      Offset(w, h - cutSize),
      Offset(w - cutSize, h),
      borderPaint,
    );
    canvas.drawLine(
      Offset(w - cutSize, h),
      Offset(w - cutSize - 20, h),
      borderPaint,
    );

    // 绘制装饰性对角线
    canvas.drawLine(
      Offset(cutSize + 40, 0),
      Offset(cutSize + 60, 20),
      accentPaint,
    );
    canvas.drawLine(
      Offset(w - cutSize - 40, h),
      Offset(w - cutSize - 60, h - 20),
      accentPaint,
    );

    // 绘制状态指示装饰线
    if (isDark) {
      final statusPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            primaryColor.withOpacity(0.7),
            primaryColor.withOpacity(0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, 100, 2));

      canvas.drawLine(
        const Offset(16, 40),
        Offset(116, 40),
        Paint()
          ..shader = statusPaint.shader
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
