// Mobile (dart:io) platform implementations

import 'lan_scan_service.dart';
import 'lan_scan/lan_scan_service_mobile.dart';
import 'network_info_service.dart';
import 'network_info/network_info_service_mobile.dart';
import 'permission_service.dart';
import 'permission/permission_service_mobile.dart';
import 'ping_service.dart';
import 'ping/ping_service_mobile.dart';
import 'speed_test_service.dart';
import 'speed_test/speed_test_service_mobile.dart';
import 'wifi_service.dart';
import 'wifi/wifi_service_mobile.dart';

WifiService createPlatformWifiService() => WifiServiceMobile();
NetworkInfoService createPlatformNetworkInfoService() =>
    NetworkInfoServiceMobile();
LanScanService createPlatformLanScanService() => LanScanServiceMobile();
SpeedTestService createPlatformSpeedTestService() =>
    SpeedTestServiceMobile();
PingService createPlatformPingService() => PingServiceMobile();
PermissionService createPlatformPermissionService() =>
    PermissionServiceMobile();
