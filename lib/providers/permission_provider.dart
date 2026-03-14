import 'package:flutter/material.dart';

import '../services/permission_service.dart';

enum PermissionState { unknown, granted, denied, permanentlyDenied }

class PermissionProvider extends ChangeNotifier {
  final PermissionService _permissionService;

  PermissionState _state = PermissionState.unknown;
  PermissionState get state => _state;

  PermissionProvider(this._permissionService);

  Future<void> checkPermission() async {
    final granted = await _permissionService.isWifiPermissionGranted();
    if (granted) {
      _state = PermissionState.granted;
    } else {
      final permanent = await _permissionService.isPermanentlyDenied();
      _state = permanent
          ? PermissionState.permanentlyDenied
          : PermissionState.denied;
    }
    notifyListeners();
  }

  Future<void> requestPermission() async {
    final granted = await _permissionService.requestWifiPermission();
    if (granted) {
      _state = PermissionState.granted;
    } else {
      final permanent = await _permissionService.isPermanentlyDenied();
      _state = permanent
          ? PermissionState.permanentlyDenied
          : PermissionState.denied;
    }
    notifyListeners();
  }

  Future<void> openSettings() async {
    await _permissionService.openSettings();
  }
}
