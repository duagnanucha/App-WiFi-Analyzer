import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../services/ad_service.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService;
  final AdService _adService;

  late AppSettings _settings;
  AppSettings get settings => _settings;

  ThemeMode get themeMode => _settings.themeMode;
  Locale get locale => Locale(_settings.languageCode);
  bool get isPro => _settings.isPro;

  SettingsProvider(this._storageService, this._adService) {
    _settings = _storageService.getSettings();
    _adService.isPro = _settings.isPro;
  }

  Future<void> setThemeMode(int themeModeIndex) async {
    _settings = _settings.copyWith(themeModeIndex: themeModeIndex);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    _settings = _settings.copyWith(languageCode: languageCode);
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }

  Future<void> setPro(bool isPro) async {
    _settings = _settings.copyWith(isPro: isPro);
    _adService.isPro = isPro;
    await _storageService.saveSettings(_settings);
    notifyListeners();
  }
}
