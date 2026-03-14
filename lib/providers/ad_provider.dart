import 'package:flutter/material.dart';

import '../services/ad_service.dart';

class AdProvider extends ChangeNotifier {
  final AdService _adService;

  bool get isPro => _adService.isPro;

  AdProvider(this._adService);

  Future<void> initialize() async {
    await _adService.initialize();
    await _adService.loadInterstitial();
  }
}
