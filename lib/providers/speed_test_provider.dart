import 'dart:async';

import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../models/speed_result.dart';
import '../services/ad_service.dart';
import '../services/ping_service.dart';
import '../services/speed_test_service.dart';
import '../services/storage_service.dart';

class SpeedTestProvider extends ChangeNotifier {
  final SpeedTestService _speedTestService;
  final PingService _pingService;
  final StorageService _storageService;
  final AdService _adService;

  SpeedTestPhase _phase = SpeedTestPhase.idle;
  SpeedTestPhase get phase => _phase;

  double _currentSpeed = 0;
  double get currentSpeed => _currentSpeed;

  double _progress = 0;
  double get progress => _progress;

  double? _downloadResult;
  double? get downloadResult => _downloadResult;

  double? _uploadResult;
  double? get uploadResult => _uploadResult;

  double? _pingResult;
  double? get pingResult => _pingResult;

  double? _packetLoss;
  double? get packetLoss => _packetLoss;

  String? _error;
  String? get error => _error;

  String _connectedSsid = '';

  StreamSubscription? _subscription;

  SpeedTestProvider(
    this._speedTestService,
    this._pingService,
    this._storageService,
    this._adService,
  );

  Future<void> startTest({String connectedSsid = ''}) async {
    _connectedSsid = connectedSsid;
    _phase = SpeedTestPhase.downloading;
    _currentSpeed = 0;
    _progress = 0;
    _downloadResult = null;
    _uploadResult = null;
    _pingResult = null;
    _packetLoss = null;
    _error = null;
    notifyListeners();

    // Run ping test first
    try {
      final summary = await _pingService.pingSummary(
        AppConstants.defaultPingHost,
        count: AppConstants.defaultPingCount,
      );
      _pingResult = summary.avgLatencyMs;
      _packetLoss = summary.packetLossPercent;
      notifyListeners();
    } catch (e) {
      debugPrint('Ping error: $e');
    }

    // Run speed test
    _subscription = _speedTestService.runSpeedTest().listen(
      (result) {
        _phase = result.phase;
        _currentSpeed = result.currentSpeed;
        _progress = result.progress;

        if (result.downloadResult != null) {
          _downloadResult = result.downloadResult;
        }
        if (result.uploadResult != null) {
          _uploadResult = result.uploadResult;
        }
        if (result.error != null) {
          _error = result.error;
        }

        if (result.phase == SpeedTestPhase.done) {
          _saveResult();
          _adService.showInterstitial();
        }

        notifyListeners();
      },
      onError: (e) {
        _phase = SpeedTestPhase.error;
        _error = e.toString();
        notifyListeners();
      },
    );
  }

  Future<void> _saveResult() async {
    if (_downloadResult != null && _uploadResult != null) {
      await _storageService.saveSpeedResult(SpeedResult(
        downloadMbps: _downloadResult!,
        uploadMbps: _uploadResult!,
        pingMs: _pingResult ?? 0,
        packetLossPercent: _packetLoss ?? 0,
        timestamp: DateTime.now(),
        connectedSsid: _connectedSsid,
      ));
    }
  }

  void reset() {
    _phase = SpeedTestPhase.idle;
    _currentSpeed = 0;
    _progress = 0;
    _downloadResult = null;
    _uploadResult = null;
    _pingResult = null;
    _packetLoss = null;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
