import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/constants/app_constants.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  int _testCount = 0;
  DateTime? _lastInterstitialTime;
  bool _isPro = false;

  bool get isPro => _isPro;
  set isPro(bool value) => _isPro = value;

  /// Initialize Mobile Ads SDK
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  /// Create a banner ad
  BannerAd createBannerAd({
    AdSize size = AdSize.banner,
    required void Function() onLoaded,
    required void Function(String error) onFailed,
  }) {
    return BannerAd(
      adUnitId: AppConstants.bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded(),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onFailed(error.message);
        },
      ),
    );
  }

  /// Pre-load an interstitial ad
  Future<void> loadInterstitial() async {
    if (_isPro) return;

    await InterstitialAd.load(
      adUnitId: AppConstants.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed to load: ${error.message}');
        },
      ),
    );
  }

  /// Show interstitial if ready and rate-limited
  Future<bool> showInterstitial() async {
    if (_isPro) return false;

    _testCount++;
    if (_testCount % AppConstants.interstitialEveryNTests != 0) return false;

    if (_lastInterstitialTime != null) {
      final elapsed = DateTime.now().difference(_lastInterstitialTime!);
      if (elapsed < AppConstants.interstitialMinInterval) return false;
    }

    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          loadInterstitial(); // Pre-load next one
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
        },
      );
      await _interstitialAd!.show();
      _lastInterstitialTime = DateTime.now();
      return true;
    }

    // Wasn't loaded, try loading for next time
    loadInterstitial();
    return false;
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}
