// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_history_entry.dart';

class ScanHistoryEntryAdapter extends TypeAdapter<ScanHistoryEntry> {
  @override
  final int typeId = 3;

  @override
  ScanHistoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScanHistoryEntry(
      timestamp: fields[0] as DateTime,
      networks: (fields[1] as List).cast<WiFiNetwork>(),
      totalNetworks: fields[2] as int,
      connectedSsid: fields[3] as String?,
      connectedRssi: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ScanHistoryEntry obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.networks)
      ..writeByte(2)
      ..write(obj.totalNetworks)
      ..writeByte(3)
      ..write(obj.connectedSsid)
      ..writeByte(4)
      ..write(obj.connectedRssi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScanHistoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
