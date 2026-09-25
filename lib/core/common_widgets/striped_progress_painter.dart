import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StripedProgressPainter extends StatefulWidget {
  const StripedProgressPainter({super.key});

  @override
  State<StripedProgressPainter> createState() => _StripedProgressPainterState();
}

class _StripedProgressPainterState extends State<StripedProgressPainter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _stripeController;

  @override
  void initState() {
    super.initState();
    _stripeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _stripeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          height: 12.h,
          width: double.infinity,
          color: const Color(0xFFFCE7F3),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    width: constraints.maxWidth * 0.65,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF472B6),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: RepaintBoundary(
                      child: AnimatedBuilder(
                        animation: _stripeController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: _AnimatedStripedProgressPainter(
                              stripeColor: const Color(0xFFF9A8D4),
                              progress: _stripeController.value,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AnimatedStripedProgressPainter extends CustomPainter {
  final Color stripeColor;
  final double progress;

  const _AnimatedStripedProgressPainter({
    required this.stripeColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // Strictly clip to rounded bounds
    canvas.clipRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(6),
      ),
    );

    final paint = Paint()
      ..color = stripeColor
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const spacing = 12.0;
    final offset = progress * spacing;
    final totalWidth = size.width + size.height * 2;

    for (double x = -size.height * 2 + offset; x < totalWidth; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x - 10, size.height), paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AnimatedStripedProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.stripeColor != stripeColor;
  }
}
