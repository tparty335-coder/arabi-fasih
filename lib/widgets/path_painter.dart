// ====================================================
// widgets/path_painter.dart
// رسام المسار المتعرج بين المهارات
// ====================================================

import 'dart:ui';
import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  final int nodeCount;
  final List<bool> isMasteredList;

  PathPainter({
    required this.nodeCount,
    required this.isMasteredList,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (nodeCount <= 1) return;

    final double nodeSpacing = 100.0;
    final double horizontalOffset = 80.0;
    final double centerX = size.width / 2;

    List<Offset> nodePositions = [];
    for (int i = 0; i < nodeCount; i++) {
      // التناوب بين اليسار واليمين
      final isLeft = i % 2 == 0;
      final x = centerX + (isLeft ? -horizontalOffset : horizontalOffset);
      final y = size.height - (i * nodeSpacing + 50.0);
      nodePositions.add(Offset(x, y));
    }

    final solidPaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dashedPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < nodePositions.length - 1; i++) {
      final p1 = nodePositions[i];
      final p2 = nodePositions[i + 1];
      final isMastered = i < isMasteredList.length && isMasteredList[i];

      final path = Path();
      path.moveTo(p1.dx, p1.dy);
      // رسم منحنى بزييه سلس بين العقدتين
      final controlPoint1 = Offset(p1.dx, (p1.dy + p2.dy) / 2);
      final controlPoint2 = Offset(p2.dx, (p1.dy + p2.dy) / 2);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p2.dx, p2.dy);

      if (isMastered) {
        canvas.drawPath(path, solidPaint);
      } else {
        _drawDashedPath(canvas, path, dashedPaint);
      }
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final PathMetrics metrics = path.computeMetrics();
    for (final PathMetric metric in metrics) {
      double distance = 0.0;
      final double dashWidth = 8.0;
      final double dashSpace = 6.0;

      while (distance < metric.length) {
        final double len = (distance + dashWidth < metric.length)
            ? dashWidth
            : metric.length - distance;
        final Path extractPath = metric.extractPath(distance, distance + len);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant PathPainter oldDelegate) {
    return oldDelegate.nodeCount != nodeCount ||
        oldDelegate.isMasteredList != isMasteredList;
  }
}
