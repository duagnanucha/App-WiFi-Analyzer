import 'dart:async';

enum SpeedTestPhase { idle, downloading, uploading, done, error }

class SpeedTestProgress {
  final SpeedTestPhase phase;
  final double currentSpeed;
  final double progress;
  final double? downloadResult;
  final double? uploadResult;
  final double? pingResult;
  final String? error;

  const SpeedTestProgress({
    required this.phase,
    this.currentSpeed = 0,
    this.progress = 0,
    this.downloadResult,
    this.uploadResult,
    this.pingResult,
    this.error,
  });
}

/// Abstract speed test service
abstract class SpeedTestService {
  Stream<SpeedTestProgress> runSpeedTest();
}
