/// Abstract network info service
abstract class NetworkInfoService {
  Future<String?> getWifiName();
  Future<String?> getWifiBSSID();
  Future<String?> getWifiIP();
  Future<String?> getWifiSubnet();
  Future<String?> getWifiGateway();
}
