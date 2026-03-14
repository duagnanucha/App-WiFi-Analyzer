// GENERATED CODE - DO NOT MODIFY BY HAND
// Run `dart run build_runner build` to regenerate

part of 'speed_result.dart';

class SpeedResultAdapter extends TypeAdapter<SpeedResult> {
  @override
  final int typeId = 1;

  @override
  SpeedResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpeedResult(
      downloadMbps: fields[0] as double,
      uploadMbps: fields[1] as double,
      pingMs: fields[2] as double,
      packetLossPercent: fields[3] as double,
      timestamp: fields[4] as DateTime,
      connectedSsid: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SpeedResult obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.downloadMbps)
      ..writeByte(1)
      ..write(obj.uploadMbps)
      ..writeByte(2)
      ..write(obj.pingMs)
      ..writeByte(3)
      ..write(obj.packetLossPercent)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.connectedSsid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpeedResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
