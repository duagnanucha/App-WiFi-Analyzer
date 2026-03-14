import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/scan_history_entry.dart';
import '../models/speed_result.dart';

class ExportService {
  /// Export scan history to CSV and return file path
  Future<String> exportScanHistory(List<ScanHistoryEntry> entries) async {
    final rows = <List<dynamic>>[
      [
        'Scan Time',
        'SSID',
        'BSSID',
        'RSSI (dBm)',
        'Channel',
        'Frequency (MHz)',
        'Band',
        'Security',
      ],
    ];

    for (final entry in entries) {
      for (final network in entry.networks) {
        rows.add([
          entry.timestamp.toIso8601String(),
          network.ssid,
          network.bssid,
          network.rssi,
          network.channel,
          network.frequency,
          network.band,
          network.security,
        ]);
      }
    }

    return _writeAndShare(rows, 'wifi_scan_history');
  }

  /// Export speed test history to CSV and return file path
  Future<String> exportSpeedHistory(List<SpeedResult> results) async {
    final rows = <List<dynamic>>[
      [
        'Time',
        'Download (Mbps)',
        'Upload (Mbps)',
        'Ping (ms)',
        'Packet Loss (%)',
        'Connected SSID',
      ],
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

    return _writeAndShare(rows, 'speed_test_history');
  }

  Future<String> _writeAndShare(
      List<List<dynamic>> rows, String filePrefix) async {
    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/${filePrefix}_$timestamp.csv');
    await file.writeAsString(csv);
    return file.path;
  }

  /// Share a file via system share sheet
  Future<void> shareFile(String filePath) async {
    await Share.shareXFiles([XFile(filePath)]);
  }
}
