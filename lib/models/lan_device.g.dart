// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lan_device.dart';

class LanDeviceAdapter extends TypeAdapter<LanDevice> {
  @override
  final int typeId = 2;

  @override
  LanDevice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LanDevice(
      ip: fields[0] as String,
      hostname: fields[1] as String?,
      macAddress: fields[2] as String?,
      discoveredAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LanDevice obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.ip)
      ..writeByte(1)
      ..write(obj.hostname)
      ..writeByte(2)
      ..write(obj.macAddress)
      ..writeByte(3)
      ..write(obj.discoveredAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanDeviceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
