import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.polygon;
    final points = [
      Offset(123, 123),
      Offset(80, 123),
      Offset(63, 83),
      // Offset(130, 200),
      // Offset(270, 100),
    ];
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, points, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
