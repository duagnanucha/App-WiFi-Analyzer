import 'package:flutter/material.dart';

import '../models/scan_history_entry.dart';
import '../models/speed_result.dart';
import '../services/export_service.dart';
import '../services/storage_service.dart';

class HistoryProvider extends ChangeNotifier {
  final StorageService _storageService;
  final ExportService _exportService;

  List<ScanHistoryEntry> _scanHistory = [];
  List<ScanHistoryEntry> get scanHistory => _scanHistory;

  List<SpeedResult> _speedHistory = [];
  List<SpeedResult> get speedHistory => _speedHistory;

  HistoryProvider(this._storageService, this._exportService);

  void loadHistory() {
    _scanHistory = _storageService.getScanHistory();
    _speedHistory = _storageService.getSpeedHistory();
    notifyListeners();
  }

  Future<void> clearScanHistory() async {
    await _storageService.clearScanHistory();
    _scanHistory = [];
    notifyListeners();
  }

  Future<void> clearSpeedHistory() async {
    await _storageService.clearSpeedHistory();
    _speedHistory = [];
    notifyListeners();
  }

  Future<void> exportScanCsv() async {
    if (_scanHistory.isEmpty) return;
    final path = await _exportService.exportScanHistory(_scanHistory);
    await _exportService.shareFile(path);
  }

  Future<void> exportSpeedCsv() async {
    if (_speedHistory.isEmpty) return;
    final path = await _exportService.exportSpeedHistory(_speedHistory);
    await _exportService.shareFile(path);
  }
}
