import 'package:flutter/material.dart';

/// Custom painter to draw dashed lines
class DashedLinePainter extends CustomPainter {
  final bool isVertical;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final Color color;

  DashedLinePainter({
    required this.isVertical,
    required this.dashWidth,
    required this.dashSpace,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double start = 0;
    final totalLength = isVertical ? size.height : size.width;
    final dashLength = dashWidth + dashSpace;

    while (start < totalLength) {
      // Draw a small dash
      double end = start + dashWidth;
      if (end > totalLength) end = totalLength;

      if (isVertical) {
        canvas.drawLine(
            Offset(size.width / 2, start), Offset(size.width / 2, end), paint);
      } else {
        canvas.drawLine(Offset(start, size.height / 2),
            Offset(end, size.height / 2), paint);
      }

      start = start + dashLength;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for the branch lines (L-shaped connection)
class BranchLinePainter extends CustomPainter {
  final bool isLastItem;
  final double strokeWidth;
  final Color color;
  final bool isDashed;
  final double dashWidth;
  final double dashSpace;

  BranchLinePainter({
    required this.isLastItem,
    required this.strokeWidth,
    required this.color,
    this.isDashed = true,
    this.dashWidth = 1,
    this.dashSpace = 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Draw horizontal line from middle to right
    if (isDashed) {
      // Draw dashed horizontal line
      double startX = size.width / 2; // Start from middle
      double endX = size.width; // Go all the way to the right
      double y = size.height / 2;

      double current = startX;
      while (current < endX) {
        double dashEnd = current + dashWidth;
        if (dashEnd > endX) dashEnd = endX;

        canvas.drawLine(
          Offset(current, y),
          Offset(dashEnd, y),
          paint,
        );

        current = current + dashWidth + dashSpace;
      }
    } else {
      // Solid line from middle to right
      canvas.drawLine(
        Offset(size.width / 2, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );
    }

    // Vertical line
    if (isLastItem) {
      // Draw only half-height vertical line if it's the last item
      if (isDashed) {
        // Draw dashed vertical line
        double startY = 0;
        double endY = size.height / 2;
        double x = size.width / 2;

        double current = startY;
        while (current < endY) {
          double dashEnd = current + dashWidth;
          if (dashEnd > endY) dashEnd = endY;

          canvas.drawLine(
            Offset(x, current),
            Offset(x, dashEnd),
            paint,
          );

          current = current + dashWidth + dashSpace;
        }
      } else {
        // Solid vertical line
        canvas.drawLine(
          Offset(size.width / 2, 0),
          Offset(size.width / 2, size.height / 2),
          paint,
        );
      }
    } else {
      // Draw full-height vertical line
      if (isDashed) {
        // Draw dashed vertical line
        double startY = 0;
        double endY = size.height;
        double x = size.width / 2;

        double current = startY;
        while (current < endY) {
          double dashEnd = current + dashWidth;
          if (dashEnd > endY) dashEnd = endY;

          canvas.drawLine(
            Offset(x, current),
            Offset(x, dashEnd),
            paint,
          );

          current = current + dashWidth + dashSpace;
        }
      } else {
        // Solid vertical line
        canvas.drawLine(
          Offset(size.width / 2, 0),
          Offset(size.width / 2, size.height),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
