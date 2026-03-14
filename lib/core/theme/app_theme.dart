import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color _seedColor = Color(0xFF1565C0);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      height: 65,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      height: 65,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );

  /// Returns color based on RSSI signal strength
  static Color signalColor(int rssi) {
    if (rssi >= -50) return Colors.green;
    if (rssi >= -60) return Colors.lightGreen;
    if (rssi >= -70) return Colors.orange;
    if (rssi >= -80) return Colors.deepOrange;
    return Colors.red;
  }

  /// Returns color for channel congestion (0.0 = free, 1.0 = congested)
  static Color congestionColor(double ratio) {
    if (ratio <= 0.25) return Colors.green;
    if (ratio <= 0.5) return Colors.orange;
    if (ratio <= 0.75) return Colors.deepOrange;
    return Colors.red;
  }
}
