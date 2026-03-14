// Web (dart:js_interop) platform implementations - uses demo data

import 'lan_scan_service.dart';
import 'lan_scan/lan_scan_service_web.dart';
import 'network_info_service.dart';
import 'network_info/network_info_service_web.dart';
import 'permission_service.dart';
import 'permission/permission_service_web.dart';
import 'ping_service.dart';
import 'ping/ping_service_web.dart';
import 'speed_test_service.dart';
import 'speed_test/speed_test_service_web.dart';
import 'wifi_service.dart';
import 'wifi/wifi_service_web.dart';

WifiService createPlatformWifiService() => WifiServiceWeb();
NetworkInfoService createPlatformNetworkInfoService() =>
    NetworkInfoServiceWeb();
LanScanService createPlatformLanScanService() => LanScanServiceWeb();
SpeedTestService createPlatformSpeedTestService() =>
    SpeedTestServiceWeb();
PingService createPlatformPingService() => PingServiceWeb();
PermissionService createPlatformPermissionService() =>
    PermissionServiceWeb();
