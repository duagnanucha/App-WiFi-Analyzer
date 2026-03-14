import 'dart:async';

import '../platform/demo_data.dart';
import '../ping_service.dart';

class PingServiceWeb implements PingService {
  @override
  Stream<PingResult> ping(String host, {int count = 10}) async* {
    for (int i = 0; i < count; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      yield PingResult(
        host: host,
        latencyMs: DemoData.generatePing(),
        isReachable: true,
      );
    }
  }

  @override
  Future<PingSummary> pingSummary(String host, {int count = 10}) async {
    final latencies = <double>[];
    for (int i = 0; i < count; i++) {
      latencies.add(DemoData.generatePing());
    }

    return PingSummary(
      host: host,
      avgLatencyMs: latencies.reduce((a, b) => a + b) / latencies.length,
      minLatencyMs: latencies.reduce((a, b) => a < b ? a : b),
      maxLatencyMs: latencies.reduce((a, b) => a > b ? a : b),
      packetLossPercent: DemoData.generatePacketLoss(),
      sent: count,
      received: count,
    );
  }
}
