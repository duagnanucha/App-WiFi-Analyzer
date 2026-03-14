import 'package:hive/hive.dart';

part 'lan_device.g.dart';

@HiveType(typeId: 2)
class LanDevice extends HiveObject {
  @HiveField(0)
  final String ip;

  @HiveField(1)
  final String? hostname;

  @HiveField(2)
  final String? macAddress;

  @HiveField(3)
  final DateTime discoveredAt;

  LanDevice({
    required this.ip,
    this.hostname,
    this.macAddress,
    required this.discoveredAt,
  });

  String get displayName => hostname ?? ip;
}
