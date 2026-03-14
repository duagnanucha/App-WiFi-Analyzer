import 'service_factory_stub.dart'
    if (dart.library.io) 'service_factory_io.dart'
    if (dart.library.js_interop) 'service_factory_web.dart';

import 'lan_scan_service.dart';
import 'network_info_service.dart';
import 'permission_service.dart';
import 'ping_service.dart';
import 'speed_test_service.dart';
import 'wifi_service.dart';

/// Creates platform-appropriate service implementations.
class ServiceFactory {
  ServiceFactory._();

  static WifiService createWifiService() => createPlatformWifiService();
  static NetworkInfoService createNetworkInfoService() =>
      createPlatformNetworkInfoService();
  static LanScanService createLanScanService() =>
      createPlatformLanScanService();
  static SpeedTestService createSpeedTestService() =>
      createPlatformSpeedTestService();
  static PingService createPingService() => createPlatformPingService();
  static PermissionService createPermissionService() =>
      createPlatformPermissionService();
}
