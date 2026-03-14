import 'dart:async';

import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../models/wifi_network.dart';
import '../services/network_info_service.dart';
import '../services/wifi_service.dart';

enum WifiSortMode { signal, name, channel }

enum WifiBandFilter { all, ghz24, ghz5 }

class WifiProvider extends ChangeNotifier {
  final WifiService _wifiService;
  final NetworkInfoService _networkInfoService;

  List<WiFiNetwork> _networks = [];
  List<WiFiNetwork> get networks => _filteredAndSorted;

  List<WiFiNetwork> get allNetworks => _networks;

  String? _connectedSsid;
  String? get connectedSsid => _connectedSsid;

  String? _connectedBssid;
  String? get connectedBssid => _connectedBssid;

  String? _wifiIp;
  String? get wifiIp => _wifiIp;

  int? _connectedRssi;
  int? get connectedRssi => _connectedRssi;

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  WifiSortMode _sortMode = WifiSortMode.signal;
  WifiSortMode get sortMode => _sortMode;

  WifiBandFilter _bandFilter = WifiBandFilter.all;
  WifiBandFilter get bandFilter => _bandFilter;

  StreamSubscription? _scanSubscription;
  Timer? _signalPollTimer;

  WifiProvider(this._wifiService, this._networkInfoService);

  List<WiFiNetwork> get _filteredAndSorted {
    var filtered = List<WiFiNetwork>.from(_networks);

    // Filter by band
    if (_bandFilter == WifiBandFilter.ghz24) {
      filtered = filtered.where((n) => n.band == '2.4 GHz').toList();
    } else if (_bandFilter == WifiBandFilter.ghz5) {
      filtered = filtered.where((n) => n.band == '5 GHz').toList();
    }

    // Sort
    switch (_sortMode) {
      case WifiSortMode.signal:
        filtered.sort((a, b) => b.rssi.compareTo(a.rssi));
        break;
      case WifiSortMode.name:
        filtered.sort(
            (a, b) => a.displayName.toLowerCase().compareTo(
                b.displayName.toLowerCase()));
        break;
      case WifiSortMode.channel:
        filtered.sort((a, b) => a.channel.compareTo(b.channel));
        break;
    }

    return filtered;
  }

  void setSortMode(WifiSortMode mode) {
    _sortMode = mode;
    notifyListeners();
  }

  void setBandFilter(WifiBandFilter filter) {
    _bandFilter = filter;
    notifyListeners();
  }

  /// Start scanning for WiFi networks
  Future<void> startScan() async {
    _isScanning = true;
    notifyListeners();

    try {
      await _wifiService.startScan();
      _networks = await _wifiService.getScannedNetworks();
      await _updateConnectionInfo();
    } catch (e) {
      debugPrint('WiFi scan error: $e');
    }

    _isScanning = false;
    notifyListeners();
  }

  /// Listen to scan results stream
  void startListening() {
    _scanSubscription = _wifiService.onResultsAvailable.listen((results) {
      _networks = results;
      _updateConnectionInfo();
      notifyListeners();
    });

    // Poll signal strength for connected network
    _signalPollTimer = Timer.periodic(
      AppConstants.signalPollInterval,
      (_) => _updateSignalStrength(),
    );
  }

  Future<void> _updateConnectionInfo() async {
    _connectedSsid = await _networkInfoService.getWifiName();
    _connectedBssid = await _networkInfoService.getWifiBSSID();
    _wifiIp = await _networkInfoService.getWifiIP();

    // Remove quotes from SSID if present
    if (_connectedSsid != null) {
      _connectedSsid = _connectedSsid!.replaceAll('"', '');
    }

    _updateSignalStrength();
  }

  void _updateSignalStrength() {
    if (_connectedBssid != null && _networks.isNotEmpty) {
      final connected = _networks.where(
        (n) => n.bssid.toLowerCase() == _connectedBssid!.toLowerCase(),
      );
      if (connected.isNotEmpty) {
        _connectedRssi = connected.first.rssi;
        notifyListeners();
      }
    }
  }

  void stopListening() {
    _scanSubscription?.cancel();
    _signalPollTimer?.cancel();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
