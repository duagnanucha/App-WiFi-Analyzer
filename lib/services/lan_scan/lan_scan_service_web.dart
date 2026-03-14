import 'dart:async';

import '../../models/lan_device.dart';
import '../lan_scan_service.dart';
import '../platform/demo_data.dart';

class LanScanServiceWeb implements LanScanService {
  @override
  Stream<LanDevice> discoverDevices(String subnet) async* {
    final devices = DemoData.generateLanDevices();
    for (final device in devices) {
      await Future.delayed(const Duration(milliseconds: 300));
      yield device;
    }
  }

  @override
  Future<void> cancel() async {}
}
