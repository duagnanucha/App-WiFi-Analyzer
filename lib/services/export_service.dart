import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/scan_history_entry.dart';
import '../models/speed_result.dart';

// Conditional imports for file operations
import 'export/export_stub.dart'
    if (dart.library.io) 'export/export_io.dart'
    if (dart.library.js_interop) 'export/export_web.dart';

class ExportService {
  Future<String> exportScanHistory(List<ScanHistoryEntry> entries) async {
    final rows = <List<dynamic>>[
      ['Scan Time', 'SSID', 'BSSID', 'RSSI (dBm)', 'Channel',
       'Frequency (MHz)', 'Band', 'Security'],
    ];
    for (final entry in entries) {
      for (final network in entry.networks) {
        rows.add([
          entry.timestamp.toIso8601String(),
          network.ssid, network.bssid, network.rssi,
          network.channel, network.frequency, network.band, network.security,
        ]);
      }
    }
    return _exportCsv(rows, 'wifi_scan_history');
  }

  Future<String> exportSpeedHistory(List<SpeedResult> results) async {
    final rows = <List<dynamic>>[
      ['Time', 'Download (Mbps)', 'Upload (Mbps)', 'Ping (ms)',
       'Packet Loss (%)', 'Connected SSID'],
    ];
    for (final result in results) {
      rows.add([
        result.timestamp.toIso8601String(),
        result.downloadMbps.toStringAsFixed(2),
        result.uploadMbps.toStringAsFixed(2),
        result.pingMs.toStringAsFixed(1),
        result.packetLossPercent.toStringAsFixed(1),
        result.connectedSsid,
      ]);
    }
    return _exportCsv(rows, 'speed_test_history');
  }

  Future<String> _exportCsv(
      List<List<dynamic>> rows, String filePrefix) async {
    final csv = const ListToCsvConverter().convert(rows);
    return saveCsvAndShare(csv, filePrefix);
  }

  Future<void> shareFile(String filePath) async {
    await platformShareFile(filePath);
  }
}
