import 'package:hive/hive.dart';

part 'wifi_network.g.dart';

@HiveType(typeId: 0)
class WiFiNetwork extends HiveObject {
  @HiveField(0)
  final String ssid;

  @HiveField(1)
  final String bssid;

  @HiveField(2)
  final int rssi;

  @HiveField(3)
  final int frequency;

  @HiveField(4)
  final int channel;

  @HiveField(5)
  final String security;

  @HiveField(6)
  final String band;

  @HiveField(7)
  final DateTime timestamp;

  WiFiNetwork({
    required this.ssid,
    required this.bssid,
    required this.rssi,
    required this.frequency,
    required this.channel,
    required this.security,
    required this.band,
    required this.timestamp,
  });

  String get displayName => ssid.isEmpty ? '(Hidden Network)' : ssid;
}
