import 'dart:async';

import 'package:wifi_scan/wifi_scan.dart';

import '../../core/utils/wifi_utils.dart';
import '../../models/wifi_network.dart';
import '../wifi_service.dart';

class WifiServiceMobile implements WifiService {
  final WiFiScan _wifiScan = WiFiScan.instance;

  @override
  Future<bool> canScan() async {
    final can = await _wifiScan.canStartScan();
    return can == CanStartScan.yes;
  }

  @override
  Future<bool> startScan() async {
    return await _wifiScan.startScan();
  }

  @override
  Future<List<WiFiNetwork>> getScannedNetworks() async {
    final can = await _wifiScan.canGetScannedResults();
    if (can != CanGetScannedResults.yes) return [];
    final results = await _wifiScan.getScannedResults();
    return results.map(_toWiFiNetwork).toList();
  }

  @override
  Stream<List<WiFiNetwork>> get onResultsAvailable {
    return _wifiScan.onScannedResultsAvailable
        .map((results) => results.map(_toWiFiNetwork).toList());
  }

  WiFiNetwork _toWiFiNetwork(WiFiAccessPoint ap) {
    return WiFiNetwork(
      ssid: ap.ssid,
      bssid: ap.bssid,
      rssi: ap.level,
      frequency: ap.frequency,
      channel: WiFiUtils.frequencyToChannel(ap.frequency),
      security: WiFiUtils.parseSecurityType(ap.capabilities),
      band: WiFiUtils.frequencyToBand(ap.frequency),
      timestamp: DateTime.now(),
    );
  }
}
