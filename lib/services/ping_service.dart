import 'dart:async';

class PingResult {
  final String host;
  final double? latencyMs;
  final bool isReachable;

  const PingResult({
    required this.host,
    this.latencyMs,
    required this.isReachable,
  });
}

class PingSummary {
  final String host;
  final double avgLatencyMs;
  final double minLatencyMs;
  final double maxLatencyMs;
  final double packetLossPercent;
  final int sent;
  final int received;

  const PingSummary({
    required this.host,
    required this.avgLatencyMs,
    required this.minLatencyMs,
    required this.maxLatencyMs,
    required this.packetLossPercent,
    required this.sent,
    required this.received,
  });
}

/// Abstract ping service
abstract class PingService {
  Stream<PingResult> ping(String host, {int count = 10});
  Future<PingSummary> pingSummary(String host, {int count = 10});
}
