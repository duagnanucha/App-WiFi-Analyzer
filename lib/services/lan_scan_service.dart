import 'dart:async';

import 'package:lan_scanner/lan_scanner.dart';

import '../models/lan_device.dart';

class LanScanService {
  LanScanner? _scanner;
  StreamSubscription? _subscription;

  /// Discover devices on the given subnet using ICMP ping
  Stream<LanDevice> discoverDevices(String subnet) {
    final controller = StreamController<LanDevice>();
    _scanner = LanScanner();

    final stream = _scanner!.icmpScan(
      subnet,
      progressCallback: (progress) {
        // Progress is 0.0 to 1.0
      },
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

  /// Cancel ongoing scan
  Future<void> cancel() async {
    await _subscription?.cancel();
    _subscription = null;
    _scanner = null;
  }
}
