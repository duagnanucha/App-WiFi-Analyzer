import 'dart:async';

import '../models/lan_device.dart';

/// Abstract LAN scanning service
abstract class LanScanService {
  Stream<LanDevice> discoverDevices(String subnet);
  Future<void> cancel();
}
