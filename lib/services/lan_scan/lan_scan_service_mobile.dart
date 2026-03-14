import 'dart:async';

import 'package:lan_scanner/lan_scanner.dart';

import '../../models/lan_device.dart';
import '../lan_scan_service.dart';

class LanScanServiceMobile implements LanScanService {
  LanScanner? _scanner;
  StreamSubscription? _subscription;

  @override
  Stream<LanDevice> discoverDevices(String subnet) {
    final controller = StreamController<LanDevice>();
    _scanner = LanScanner();

    final stream = _scanner!.icmpScan(
      subnet,
      progressCallback: (progress) {},
    );

    _subscription = stream.listen(
      (host) {
        if (host.isReachable) {
          controller.add(LanDevice(
            ip: host.internetAddress.address,
            discoveredAt: DateTime.now(),
          ));
        }
      },
      onDone: () => controller.close(),
      onError: (e) => controller.addError(e),
    );

    return controller.stream;
  }

  @override
  Future<void> cancel() async {
    await _subscription?.cancel();
    _subscription = null;
    _scanner = null;
  }
}
