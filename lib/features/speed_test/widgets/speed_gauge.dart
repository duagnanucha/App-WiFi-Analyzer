import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../services/speed_test_service.dart';

class SpeedGauge extends StatelessWidget {
  final double speed;
  final SpeedTestPhase phase;

  const SpeedGauge({
    super.key,
    required this.speed,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Normalize speed: 0 Mbps = 0, 100+ Mbps = 1.0
    final normalized = (speed / 100).clamp(0.0, 1.0);
    final isActive = phase == SpeedTestPhase.downloading ||
        phase == SpeedTestPhase.uploading;

    return CustomPaint(
      painter: _SpeedGaugePainter(
        value: isActive ? normalized : 0,
        color: phase == SpeedTestPhase.downloading
            ? Colors.green
            : phase == SpeedTestPhase.uploading
                ? Colors.blue
                : theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isActive ? Formatters.formatSpeed(speed) : '--',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isActive)
              Text(
                phase == SpeedTestPhase.downloading
                    ? 'Download'
                    : 'Upload',
                style: theme.textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}

class _SpeedGaugePainter extends CustomPainter {
  final double value;
  final Color color;
  final Color backgroundColor;

  _SpeedGaugePainter({
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.65);
    final radius = min(size.width / 2.5, size.height * 0.55);
    const startAngle = 0.75 * pi;
    const sweepAngle = 1.5 * pi;
    const strokeWidth = 12.0;

    // Background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = backgroundColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );

    // Value arc
    if (value > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle * value,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_SpeedGaugePainter oldDelegate) =>
      value != oldDelegate.value || color != oldDelegate.color;
}
