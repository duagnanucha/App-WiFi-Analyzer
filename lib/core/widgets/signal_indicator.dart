import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SignalIndicator extends StatelessWidget {
  final int rssi;
  final double size;

  const SignalIndicator({
    super.key,
    required this.rssi,
    this.size = 24,
  });

  int get _bars {
    if (rssi >= -50) return 4;
    if (rssi >= -60) return 3;
    if (rssi >= -70) return 2;
    if (rssi >= -80) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.signalColor(rssi);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SignalPainter(bars: _bars, color: color),
      ),
    );
  }
}

class _SignalPainter extends CustomPainter {
  final int bars;
  final Color color;

  _SignalPainter({required this.bars, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / 5;
    final gap = barWidth * 0.3;
    final totalBarWidth = barWidth - gap;

    for (int i = 0; i < 4; i++) {
      final height = size.height * (0.25 + i * 0.25);
      final x = i * (totalBarWidth + gap);
      final y = size.height - height;

      final paint = Paint()
        ..color = i < bars ? color : color.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, totalBarWidth, height),
          const Radius.circular(1),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SignalPainter oldDelegate) =>
      bars != oldDelegate.bars || color != oldDelegate.color;
}
