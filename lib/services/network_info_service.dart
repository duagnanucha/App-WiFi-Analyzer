import 'package:network_info_plus/network_info_plus.dart';

class NetworkInfoService {
  final NetworkInfo _networkInfo = NetworkInfo();

  Future<String?> getWifiName() async {
    try {
      return await _networkInfo.getWifiName();
    } catch (_) {
      return null;
    }
  }

  Future<String?> getWifiBSSID() async {
    try {
      return await _networkInfo.getWifiBSSID();
    } catch (_) {
      return null;
    }
  }

  Future<String?> getWifiIP() async {
    try {
      return await _networkInfo.getWifiIP();
    } catch (_) {
      return null;
    }
  }

  Future<String?> getWifiSubnet() async {
    try {
      return await _networkInfo.getWifiSubmask();
    } catch (_) {
      return null;
    }
  }

  Future<String?> getWifiGateway() async {
    try {
      return await _networkInfo.getWifiGatewayIP();
    } catch (_) {
      return null;
    }
  }
}
