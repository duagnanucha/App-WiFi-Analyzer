/// Abstract permission service
abstract class PermissionService {
  Future<bool> isWifiPermissionGranted();
  Future<bool> requestWifiPermission();
  Future<bool> isPermanentlyDenied();
  Future<bool> openSettings();
}
