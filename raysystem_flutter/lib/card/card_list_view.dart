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

class EvaMonitorCard extends StatefulWidget {
  final Widget child;

  const EvaMonitorCard({
    super.key,
    required this.child,
  });

  @override
  State<EvaMonitorCard> createState() => _EvaMonitorCardState();
}

class _EvaMonitorCardState extends State<EvaMonitorCard> with SingleTickerProviderStateMixin {
  double _scanLinePosition = 0.0;
  Timer? _scanLineTimer;
  late AnimationController _warningController;
  bool _showWarning = false;

  @override
  void initState() {
    super.initState();
    _startScanLineAnimation();
    _warningController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _warningController.reverse();
      } else if (status == AnimationStatus.dismissed && _showWarning) {
        _warningController.forward();
      }
    });

    // 模拟随机警告效果，实际使用时应该基于真实状态
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _showWarning = !_showWarning;
        if (_showWarning) {
          _warningController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _scanLineTimer?.cancel();
    _warningController.dispose();
    super.dispose();
  }

  void _startScanLineAnimation() {
    _scanLineTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _scanLinePosition += 2;
        if (_scanLinePosition > 300) {
          _scanLinePosition = 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? const Color(0xFFFF6600) : theme.primaryColor;
    final accentColor = isDark ? const Color(0xFF00FF00) : theme.primaryColor;
    final warningColor = isDark ? const Color(0xFFFF0033) : Colors.red;

    return AnimatedBuilder(
      animation: _warningController,
      builder: (context, child) {
        final warningValue = _warningController.value;
        return Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A2A) : theme.cardTheme.color,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Color.lerp(
                  primaryColor.withOpacity(0.2),
                  warningColor.withOpacity(0.3),
                  warningValue,
                )!,
                blurRadius: 12 + (warningValue * 4),
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
                  color: Color.lerp(
                    primaryColor.withOpacity(0.5),
                    warningColor.withOpacity(0.7),
                    warningValue,
                  )!,
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: EvaCardDecorationPainter(
                        primaryColor: Color.lerp(
                          primaryColor,
                          warningColor,
                          warningValue,
                        )!,
                        accentColor: accentColor,
                        isDark: isDark,
                        warningValue: warningValue,
                      ),
                    ),
                  ),
                  
                  // MAGI 风格的扫描线
                  if (!_showWarning) ...[
                    Positioned(
                      top: _scanLinePosition,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.withOpacity(0),
                              primaryColor.withOpacity(0.3),
                              primaryColor.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],

                  // 警告效果
                  if (_showWarning) ...[
                    Positioned.fill(
                      child: CustomPaint(
                        painter: WarningEffectPainter(
                          warningColor: warningColor,
                          warningValue: warningValue,
                        ),
                      ),
                    ),
                  ],

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
                                color: _showWarning ? warningColor : accentColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: (_showWarning ? warningColor : accentColor).withOpacity(0.5),
                                    blurRadius: 4 + (warningValue * 4),
                                    spreadRadius: 1 + warningValue,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              _showWarning ? 'WARNING' : 'MONITOR ACTIVE',
                              style: TextStyle(
                                fontSize: 10,
                                color: _showWarning ? warningColor : accentColor,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        widget.child,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
  final double warningValue;

  EvaCardDecorationPainter({
    required this.primaryColor,
    required this.accentColor,
    required this.isDark,
    required this.warningValue,
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

class WarningEffectPainter extends CustomPainter {
  final Color warningColor;
  final double warningValue;

  WarningEffectPainter({
    required this.warningColor,
    required this.warningValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final warningPaint = Paint()
      ..color = warningColor.withOpacity(0.1 * warningValue)
      ..style = PaintingStyle.fill;

    // 绘制警告效果
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      warningPaint,
    );

    // 绘制警告条纹
    final stripePaint = Paint()
      ..color = warningColor.withOpacity(0.2 * warningValue)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var i = 0; i < size.height; i += 20) {
      canvas.drawLine(
        Offset(0, i + (warningValue * 10)),
        Offset(size.width, i),
        stripePaint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
