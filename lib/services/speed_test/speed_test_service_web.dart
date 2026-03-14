import 'dart:async';

import '../platform/demo_data.dart';
import '../speed_test_service.dart';

class SpeedTestServiceWeb implements SpeedTestService {
  @override
  Stream<SpeedTestProgress> runSpeedTest() async* {
    // Simulate download phase
    final downloadTarget = DemoData.generateDownloadSpeed();
    for (int i = 1; i <= 20; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      yield SpeedTestProgress(
        phase: SpeedTestPhase.downloading,
        currentSpeed: downloadTarget * (i / 20) + (i % 3) * 2,
        progress: i / 20,
      );
    }

    // Simulate upload phase
    final uploadTarget = DemoData.generateUploadSpeed();
    for (int i = 1; i <= 20; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      yield SpeedTestProgress(
        phase: SpeedTestPhase.uploading,
        currentSpeed: uploadTarget * (i / 20) + (i % 3),
        progress: i / 20,
      );
    }

    // Done
    yield SpeedTestProgress(
      phase: SpeedTestPhase.done,
      downloadResult: downloadTarget,
      uploadResult: uploadTarget,
      pingResult: DemoData.generatePing(),
    );
  }
}
