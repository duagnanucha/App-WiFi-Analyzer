// Stub file for conditional import - should never be used directly.
// This is selected when neither dart.library.io nor dart.library.js_interop
// is available (shouldn't happen in practice).

import 'lan_scan_service.dart';
import 'network_info_service.dart';
import 'permission_service.dart';
import 'ping_service.dart';
import 'speed_test_service.dart';
import 'wifi_service.dart';

WifiService createPlatformWifiService() =>
    throw UnsupportedError('Platform not supported');
NetworkInfoService createPlatformNetworkInfoService() =>
    throw UnsupportedError('Platform not supported');
LanScanService createPlatformLanScanService() =>
    throw UnsupportedError('Platform not supported');
SpeedTestService createPlatformSpeedTestService() =>
    throw UnsupportedError('Platform not supported');
PingService createPlatformPingService() =>
    throw UnsupportedError('Platform not supported');
PermissionService createPlatformPermissionService() =>
    throw UnsupportedError('Platform not supported');
