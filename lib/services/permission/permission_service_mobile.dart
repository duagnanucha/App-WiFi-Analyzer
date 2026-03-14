import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

import '../permission_service.dart';

class PermissionServiceMobile implements PermissionService {
  @override
  Future<bool> isWifiPermissionGranted() async {
    if (Platform.isAndroid) {
      final nearbyStatus = await Permission.nearbyWifiDevices.status;
      if (nearbyStatus.isGranted) return true;
      final locationStatus = await Permission.locationWhenInUse.status;
      return locationStatus.isGranted;
    }
    return false;
  }

  @override
  Future<bool> requestWifiPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.nearbyWifiDevices.request();
      if (status.isGranted) return true;
      status = await Permission.locationWhenInUse.request();
      return status.isGranted;
    }
    return false;
  }

  @override
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

  @override
  Future<bool> openSettings() => openAppSettings();
}
