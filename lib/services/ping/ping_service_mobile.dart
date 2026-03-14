import 'dart:async';

import 'package:dart_ping/dart_ping.dart' as dp;

import '../ping_service.dart';

class PingServiceMobile implements PingService {
  @override
  Stream<PingResult> ping(String host, {int count = 10}) {
    final ping = dp.Ping(host, count: count);
    return ping.stream
        .where((event) => event.response != null)
        .map((event) {
      final response = event.response!;
      return PingResult(
        host: host,
        latencyMs: response.time?.inMicroseconds != null
            ? response.time!.inMicroseconds / 1000.0
            : null,
        isReachable: response.time != null,
      );
    });
  }

  @override
  Future<PingSummary> pingSummary(String host, {int count = 10}) async {
    final results = <PingResult>[];
    await for (final result in ping(host, count: count)) {
      results.add(result);
    }

    final successful =
        results.where((r) => r.isReachable && r.latencyMs != null).toList();
    final latencies = successful.map((r) => r.latencyMs!).toList();

    if (latencies.isEmpty) {
      return PingSummary(
        host: host,
        avgLatencyMs: 0,
        minLatencyMs: 0,
        maxLatencyMs: 0,
        packetLossPercent: 100,
        sent: count,
        received: 0,
      );
    }

    return PingSummary(
      host: host,
      avgLatencyMs: latencies.reduce((a, b) => a + b) / latencies.length,
      minLatencyMs: latencies.reduce((a, b) => a < b ? a : b),
      maxLatencyMs: latencies.reduce((a, b) => a > b ? a : b),
      packetLossPercent:
          ((count - successful.length) / count * 100).clamp(0, 100),
      sent: count,
      received: successful.length,
    );
  }
}
