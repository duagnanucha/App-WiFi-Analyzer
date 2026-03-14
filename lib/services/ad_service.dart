import 'package:flutter/foundation.dart' show kIsWeb;

import '../core/constants/app_constants.dart';

/// Ad service - disabled on web (google_mobile_ads doesn't support web)
class AdService {
  int _testCount = 0;
  DateTime? _lastInterstitialTime;
  bool _isPro = false;

  bool get isPro => _isPro;
  set isPro(bool value) => _isPro = value;

  Future<void> initialize() async {
    if (kIsWeb) return;
    await _initializeMobile();
  }

  Future<void> _initializeMobile() async {
    // Dynamically handled in mobile-specific code
  }

  Future<void> loadInterstitial() async {
    if (kIsWeb || _isPro) return;
  }

  Future<bool> showInterstitial() async {
    if (kIsWeb || _isPro) return false;

    _testCount++;
    if (_testCount % AppConstants.interstitialEveryNTests != 0) return false;

    if (_lastInterstitialTime != null) {
      final elapsed = DateTime.now().difference(_lastInterstitialTime!);
      if (elapsed < AppConstants.interstitialMinInterval) return false;
    }

    _lastInterstitialTime = DateTime.now();
    return false; // Will be overridden by mobile implementation
  }

  void dispose() {}
}
