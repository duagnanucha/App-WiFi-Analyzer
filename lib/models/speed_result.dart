import 'package:hive/hive.dart';

part 'speed_result.g.dart';

@HiveType(typeId: 1)
class SpeedResult extends HiveObject {
  @HiveField(0)
  final double downloadMbps;

  @HiveField(1)
  final double uploadMbps;

  @HiveField(2)
  final double pingMs;

  @HiveField(3)
  final double packetLossPercent;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final String connectedSsid;

  SpeedResult({
    required this.downloadMbps,
    required this.uploadMbps,
    required this.pingMs,
    required this.packetLossPercent,
    required this.timestamp,
    required this.connectedSsid,
  });
}
