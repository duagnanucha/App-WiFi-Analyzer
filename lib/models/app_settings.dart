import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'app_settings.g.dart';

@HiveType(typeId: 4)
class AppSettings extends HiveObject {
  @HiveField(0)
  final int themeModeIndex; // 0=system, 1=light, 2=dark

  @HiveField(1)
  final String languageCode;

  @HiveField(2)
  final bool isPro;

  AppSettings({
    this.themeModeIndex = 0,
    this.languageCode = 'en',
    this.isPro = false,
  });

  ThemeMode get themeMode {
    switch (themeModeIndex) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  AppSettings copyWith({
    int? themeModeIndex,
    String? languageCode,
    bool? isPro,
  }) {
    return AppSettings(
      themeModeIndex: themeModeIndex ?? this.themeModeIndex,
      languageCode: languageCode ?? this.languageCode,
      isPro: isPro ?? this.isPro,
    );
  }
}
