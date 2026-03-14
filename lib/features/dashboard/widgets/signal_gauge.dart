import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class SignalGauge extends StatelessWidget {
  final int rssi;

  const SignalGauge({super.key, required this.rssi});

  @override
  Widget build(BuildContext context) {
    // Map RSSI (-100 to -30) to angle (0 to 1)
    final normalized = ((rssi + 100) / 70).clamp(0.0, 1.0);
    final color = AppTheme.signalColor(rssi);

    return CustomPaint(
      painter: _GaugePainter(
        value: normalized,
        color: color,
        backgroundColor:
            Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;
  final Color backgroundColor;

  _GaugePainter({
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.85);
    final radius = min(size.width / 2, size.height * 0.8);
    const startAngle = pi;
    const sweepAngle = pi;
    const strokeWidth = 16.0;

    // Background arc
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Value arc
    final valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * value,
      false,
      valuePaint,
    );

    // Needle indicator
    final needleAngle = startAngle + sweepAngle * value;
    final needleEnd = Offset(
      center.dx + (radius - strokeWidth) * cos(needleAngle),
      center.dy + (radius - strokeWidth) * sin(needleAngle),
    );

    final needlePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(needleEnd, 6, needlePaint);
    canvas.drawCircle(center, 4, needlePaint);
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      value != oldDelegate.value || color != oldDelegate.color;
}
