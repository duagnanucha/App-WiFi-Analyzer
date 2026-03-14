import 'package:hive/hive.dart';
import 'wifi_network.dart';

part 'scan_history_entry.g.dart';

@HiveType(typeId: 3)
class ScanHistoryEntry extends HiveObject {
  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final List<WiFiNetwork> networks;

  @HiveField(2)
  final int totalNetworks;

  @HiveField(3)
  final String? connectedSsid;

  @HiveField(4)
  final int? connectedRssi;

  ScanHistoryEntry({
    required this.timestamp,
    required this.networks,
    required this.totalNetworks,
    this.connectedSsid,
    this.connectedRssi,
  });
}
