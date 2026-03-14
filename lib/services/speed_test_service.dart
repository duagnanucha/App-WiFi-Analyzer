import 'dart:async';

import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';

enum SpeedTestPhase { idle, downloading, uploading, done, error }

class SpeedTestProgress {
  final SpeedTestPhase phase;
  final double currentSpeed; // Mbps
  final double progress; // 0.0 to 1.0
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

class SpeedTestService {
  final FlutterInternetSpeedTest _speedTest = FlutterInternetSpeedTest();

  /// Run a full speed test (download + upload)
  Stream<SpeedTestProgress> runSpeedTest() {
    final controller = StreamController<SpeedTestProgress>();
    double? downloadResult;
    double? uploadResult;

    _speedTest.startTesting(
      onStarted: () {
        controller.add(const SpeedTestProgress(
          phase: SpeedTestPhase.downloading,
        ));
      },
      onProgress: (double percent, TestResult data) {
        final phase = data.type == TestType.download
            ? SpeedTestPhase.downloading
            : SpeedTestPhase.uploading;
        controller.add(SpeedTestProgress(
          phase: phase,
          currentSpeed: data.transferRate,
          progress: percent / 100,
        ));
      },
      onDownloadComplete: (TestResult data) {
        downloadResult = data.transferRate;
      },
      onUploadComplete: (TestResult data) {
        uploadResult = data.transferRate;
      },
      onCompleted: (TestResult download, TestResult upload) {
        controller.add(SpeedTestProgress(
          phase: SpeedTestPhase.done,
          downloadResult: downloadResult ?? download.transferRate,
          uploadResult: uploadResult ?? upload.transferRate,
        ));
        controller.close();
      },
      onError: (String errorMessage, String speedTestError) {
        controller.add(SpeedTestProgress(
          phase: SpeedTestPhase.error,
          error: errorMessage,
        ));
        controller.close();
      },
      onDefaultServerSelectionDone: (Client? client) {},
      onDefaultServerSelectionInProgress: () {},
      onCancel: () {
        controller.close();
      },
    );

    return controller.stream;
  }
}
