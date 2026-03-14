import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Check if WiFi scan permissions are granted
  Future<bool> isWifiPermissionGranted() async {
    if (Platform.isAndroid) {
      // Android 13+ uses NEARBY_WIFI_DEVICES
      final nearbyStatus = await Permission.nearbyWifiDevices.status;
      if (nearbyStatus.isGranted) return true;

      // Older Android uses location
      final locationStatus = await Permission.locationWhenInUse.status;
      return locationStatus.isGranted;
    }
    return false;
  }

  /// Request WiFi scan permissions
  Future<bool> requestWifiPermission() async {
    if (Platform.isAndroid) {
      // Try NEARBY_WIFI_DEVICES first (Android 13+)
      var status = await Permission.nearbyWifiDevices.request();
      if (status.isGranted) return true;

      // Fallback to location permission (Android 12 and below)
      status = await Permission.locationWhenInUse.request();
      return status.isGranted;
    }
    return false;
  }

  /// Check if permission is permanently denied
  Future<bool> isPermanentlyDenied() async {
    if (Platform.isAndroid) {
      final nearbyDenied =
          await Permission.nearbyWifiDevices.isPermanentlyDenied;
      final locationDenied =
          await Permission.locationWhenInUse.isPermanentlyDenied;
      return nearbyDenied && locationDenied;
    }
    return false;
  }

  /// Open app settings for user to manually grant permission
  Future<bool> openSettings() => openAppSettings();
}
