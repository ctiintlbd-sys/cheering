import 'dart:ui';
import 'package:cheering/core/theme/app_theme_colors.dart';
import 'package:flutter/material.dart';

class DottedBorderWidget extends StatelessWidget {
  const DottedBorderWidget({
    super.key,
    required this.child,
    this.color,
    this.strokeWidth = 1,
    this.dashLength = 3,
    this.gapLength = 2,
    this.radius = 12,
  });

  final Widget child;
  final Color? color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedBorderPainter(
        color: color ?? context.colors.borderPrimary,
        strokeWidth: strokeWidth,
        dashLength: dashLength,
        gapLength: gapLength,
        radius: radius,
      ),
      child: child,
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  _DottedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashLength = 6,
    this.gapLength = 4,
    this.radius = 12,
  });

  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double gapLength;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    final PathMetrics metrics = path.computeMetrics();
    for (final PathMetric metric in metrics) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final len = draw ? dashLength : gapLength;
        if (draw) {
          canvas.drawPath(metric.extractPath(distance, distance + len), paint);
        }
        distance += len;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(_DottedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dashLength != dashLength ||
      oldDelegate.gapLength != gapLength ||
      oldDelegate.radius != radius;
}
