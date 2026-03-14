import 'package:network_info_plus/network_info_plus.dart';

import '../network_info_service.dart';

class NetworkInfoServiceMobile implements NetworkInfoService {
  final NetworkInfo _networkInfo = NetworkInfo();

  @override
  Future<String?> getWifiName() async {
    try {
      return await _networkInfo.getWifiName();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getWifiBSSID() async {
    try {
      return await _networkInfo.getWifiBSSID();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getWifiIP() async {
    try {
      return await _networkInfo.getWifiIP();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getWifiSubnet() async {
    try {
      return await _networkInfo.getWifiSubmask();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> getWifiGateway() async {
    try {
      return await _networkInfo.getWifiGatewayIP();
    } catch (_) {
      return null;
    }
  }
}
