// GENERATED CODE - DO NOT MODIFY BY HAND
// Run `dart run build_runner build` to regenerate

part of 'wifi_network.dart';

class WiFiNetworkAdapter extends TypeAdapter<WiFiNetwork> {
  @override
  final int typeId = 0;

  @override
  WiFiNetwork read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WiFiNetwork(
      ssid: fields[0] as String,
      bssid: fields[1] as String,
      rssi: fields[2] as int,
      frequency: fields[3] as int,
      channel: fields[4] as int,
      security: fields[5] as String,
      band: fields[6] as String,
      timestamp: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WiFiNetwork obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.ssid)
      ..writeByte(1)
      ..write(obj.bssid)
      ..writeByte(2)
      ..write(obj.rssi)
      ..writeByte(3)
      ..write(obj.frequency)
      ..writeByte(4)
      ..write(obj.channel)
      ..writeByte(5)
      ..write(obj.security)
      ..writeByte(6)
      ..write(obj.band)
      ..writeByte(7)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WiFiNetworkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
