import 'dart:async';

import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';

import '../speed_test_service.dart';

class SpeedTestServiceMobile implements SpeedTestService {
  final FlutterInternetSpeedTest _speedTest = FlutterInternetSpeedTest();

  @override
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
