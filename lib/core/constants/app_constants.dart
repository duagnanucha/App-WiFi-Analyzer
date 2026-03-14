class AppConstants {
  AppConstants._();

  static const String appName = 'WiFi Analyzer Pro';

  // AdMob Test IDs (replace with real IDs for production)
  static const String adMobAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String interstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';

  // Scan intervals
  static const Duration signalPollInterval = Duration(seconds: 2);
  static const Duration wifiScanInterval = Duration(seconds: 30);

  // Interstitial rate limiting
  static const int interstitialEveryNTests = 3;
  static const Duration interstitialMinInterval = Duration(minutes: 3);

  // Hive box names
  static const String scanHistoryBox = 'scan_history';
  static const String speedResultBox = 'speed_results';
  static const String settingsBox = 'settings';

  // Ping defaults
  static const String defaultPingHost = '8.8.8.8';
  static const int defaultPingCount = 10;
}
