import 'dart:async';

import '../models/wifi_network.dart';

/// Abstract WiFi scanning service
abstract class WifiService {
  Future<bool> canScan();
  Future<bool> startScan();
  Future<List<WiFiNetwork>> getScannedNetworks();
  Stream<List<WiFiNetwork>> get onResultsAvailable;
}
