import 'dart:async';

import 'package:flutter/material.dart';

import '../core/utils/network_utils.dart';
import '../models/lan_device.dart';
import '../services/lan_scan_service.dart';
import '../services/network_info_service.dart';

class LanScannerProvider extends ChangeNotifier {
  final LanScanService _lanScanService;
  final NetworkInfoService _networkInfoService;

  List<LanDevice> _devices = [];
  List<LanDevice> get devices => _devices;

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  double _progress = 0;
  double get progress => _progress;

  StreamSubscription? _subscription;

  LanScannerProvider(this._lanScanService, this._networkInfoService);

  Future<void> startScan() async {
    _isScanning = true;
    _devices = [];
    _progress = 0;
    notifyListeners();

    try {
      final ip = await _networkInfoService.getWifiIP();
      if (ip == null) {
        _isScanning = false;
        notifyListeners();
        return;
      }

      final subnet = NetworkUtils.getSubnet(ip);

      _subscription = _lanScanService.discoverDevices(subnet).listen(
        (device) {
          _devices.add(device);
          _progress = _devices.length / 255; // Approximate
          notifyListeners();
        },
        onDone: () {
          _isScanning = false;
          _progress = 1.0;
          notifyListeners();
        },
        onError: (e) {
          debugPrint('LAN scan error: $e');
          _isScanning = false;
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint('LAN scan error: $e');
      _isScanning = false;
      notifyListeners();
    }
  }

  Future<void> stopScan() async {
    await _subscription?.cancel();
    await _lanScanService.cancel();
    _isScanning = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
