import 'package:hive_flutter/hive_flutter.dart';

import '../core/constants/app_constants.dart';
import '../models/app_settings.dart';
import '../models/scan_history_entry.dart';
import '../models/speed_result.dart';
import '../models/wifi_network.dart';
import '../models/lan_device.dart';

class StorageService {
  late Box<ScanHistoryEntry> _scanHistoryBox;
  late Box<SpeedResult> _speedResultBox;
  late Box<AppSettings> _settingsBox;

  /// Initialize Hive and register adapters
  Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(WiFiNetworkAdapter());
    Hive.registerAdapter(SpeedResultAdapter());
    Hive.registerAdapter(LanDeviceAdapter());
    Hive.registerAdapter(ScanHistoryEntryAdapter());
    Hive.registerAdapter(AppSettingsAdapter());

    _scanHistoryBox =
        await Hive.openBox<ScanHistoryEntry>(AppConstants.scanHistoryBox);
    _speedResultBox =
        await Hive.openBox<SpeedResult>(AppConstants.speedResultBox);
    _settingsBox = await Hive.openBox<AppSettings>(AppConstants.settingsBox);
  }

  // --- Scan History ---

  Future<void> saveScanHistory(ScanHistoryEntry entry) async {
    await _scanHistoryBox.add(entry);
  }

  List<ScanHistoryEntry> getScanHistory() {
    final entries = _scanHistoryBox.values.toList();
    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }

  Future<void> clearScanHistory() async {
    await _scanHistoryBox.clear();
  }

  // --- Speed Results ---

  Future<void> saveSpeedResult(SpeedResult result) async {
    await _speedResultBox.add(result);
  }

  List<SpeedResult> getSpeedHistory() {
    final results = _speedResultBox.values.toList();
    results.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return results;
  }

  Future<void> clearSpeedHistory() async {
    await _speedResultBox.clear();
  }

  // --- Settings ---

  AppSettings getSettings() {
    return _settingsBox.get('settings') ?? AppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    await _settingsBox.put('settings', settings);
  }
}
