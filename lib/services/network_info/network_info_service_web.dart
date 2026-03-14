import '../network_info_service.dart';

class NetworkInfoServiceWeb implements NetworkInfoService {
  @override
  Future<String?> getWifiName() async => 'HomeWiFi-5G';

  @override
  Future<String?> getWifiBSSID() async => 'AA:BB:CC:DD:EE:01';

  @override
  Future<String?> getWifiIP() async => '192.168.1.105';

  @override
  Future<String?> getWifiSubnet() async => '255.255.255.0';

  @override
  Future<String?> getWifiGateway() async => '192.168.1.1';
}
