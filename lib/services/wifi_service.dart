import 'dart:async';

import 'package:wifi_scan/wifi_scan.dart';

import '../core/utils/wifi_utils.dart';
import '../models/wifi_network.dart';

class WifiService {
  final WiFiScan _wifiScan = WiFiScan.instance;

  /// Check if scanning is supported
  Future<bool> canScan() async {
    final can = await _wifiScan.canStartScan();
    return can == CanStartScan.yes;
  }

  /// Trigger a new WiFi scan
  Future<bool> startScan() async {
    final result = await _wifiScan.startScan();
    return result;
  }

  /// Get last scanned results as WiFiNetwork models
  Future<List<WiFiNetwork>> getScannedNetworks() async {
    final can = await _wifiScan.canGetScannedResults();
    if (can != CanGetScannedResults.yes) return [];

    final results = await _wifiScan.getScannedResults();
    return results.map(_toWiFiNetwork).toList();
  }

  /// Stream of scan results
  Stream<List<WiFiNetwork>> get onResultsAvailable {
    return _wifiScan.onScannedResultsAvailable
        .map((results) => results.map(_toWiFiNetwork).toList());
  }

  WiFiNetwork _toWiFiNetwork(WiFiAccessPoint ap) {
    final channel = WiFiUtils.frequencyToChannel(ap.frequency);
    final band = WiFiUtils.frequencyToBand(ap.frequency);
    final security = WiFiUtils.parseSecurityType(ap.capabilities);

    return WiFiNetwork(
      ssid: ap.ssid,
      bssid: ap.bssid,
      rssi: ap.level,
      frequency: ap.frequency,
      channel: channel,
      security: security,
      band: band,
      timestamp: DateTime.now(),
    );
  }
}
