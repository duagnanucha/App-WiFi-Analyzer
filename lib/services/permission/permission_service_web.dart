import '../permission_service.dart';

class PermissionServiceWeb implements PermissionService {
  @override
  Future<bool> isWifiPermissionGranted() async => true;

  @override
  Future<bool> requestWifiPermission() async => true;

  @override
  Future<bool> isPermanentlyDenied() async => false;

  @override
  Future<bool> openSettings() async => false;
}
