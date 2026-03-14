import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/formatters.dart';
import '../../core/widgets/ad_banner_widget.dart';
import '../../providers/speed_test_provider.dart';
import '../../providers/wifi_provider.dart';
import '../../services/speed_test_service.dart';
import 'widgets/speed_gauge.dart';

class SpeedTestScreen extends StatelessWidget {
  const SpeedTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final speedTest = context.watch<SpeedTestProvider>();
    final wifi = context.watch<WifiProvider>();
    final theme = Theme.of(context);
    final isIdle = speedTest.phase == SpeedTestPhase.idle;
    final isDone = speedTest.phase == SpeedTestPhase.done;
    final isError = speedTest.phase == SpeedTestPhase.error;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Speed Gauge
          SizedBox(
            height: 250,
            child: SpeedGauge(
              speed: speedTest.currentSpeed,
              phase: speedTest.phase,
            ),
          ),

          const SizedBox(height: 16),

          // Status text
          Text(
            _phaseText(speedTest.phase),
            style: theme.textTheme.titleMedium,
          ),

          if (speedTest.progress > 0 && !isDone && !isError) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(value: speedTest.progress),
          ],

          const SizedBox(height: 24),

          // Start/Reset button
          FilledButton.icon(
            onPressed: isIdle || isDone || isError
                ? () => speedTest.startTest(
                      connectedSsid: wifi.connectedSsid ?? '',
                    )
                : null,
            icon: Icon(isIdle ? Icons.play_arrow : Icons.refresh),
            label: Text(isIdle ? 'Start Test' : 'Test Again'),
          ),

          const SizedBox(height: 24),

          // Results
          if (speedTest.downloadResult != null ||
              speedTest.uploadResult != null ||
              speedTest.pingResult != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('Results', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (speedTest.downloadResult != null)
                          _ResultItem(
                            icon: Icons.download,
                            label: 'Download',
                            value: Formatters.formatSpeed(
                                speedTest.downloadResult!),
                            color: Colors.green,
                          ),
                        if (speedTest.uploadResult != null)
                          _ResultItem(
                            icon: Icons.upload,
                            label: 'Upload',
                            value: Formatters.formatSpeed(
                                speedTest.uploadResult!),
                            color: Colors.blue,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (speedTest.pingResult != null)
                          _ResultItem(
                            icon: Icons.timer,
                            label: 'Ping',
                            value:
                                Formatters.formatPing(speedTest.pingResult!),
                            color: Colors.orange,
                          ),
                        if (speedTest.packetLoss != null)
                          _ResultItem(
                            icon: Icons.error_outline,
                            label: 'Loss',
                            value: Formatters.formatPacketLoss(
                                speedTest.packetLoss!),
                            color: speedTest.packetLoss! > 0
                                ? Colors.red
                                : Colors.green,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          if (speedTest.error != null) ...[
            const SizedBox(height: 16),
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error: ${speedTest.error}',
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),
          const AdBannerWidget(),
        ],
      ),
    );
  }

  String _phaseText(SpeedTestPhase phase) {
    switch (phase) {
      case SpeedTestPhase.idle:
        return 'Ready to test';
      case SpeedTestPhase.downloading:
        return 'Testing download speed...';
      case SpeedTestPhase.uploading:
        return 'Testing upload speed...';
      case SpeedTestPhase.done:
        return 'Test complete';
      case SpeedTestPhase.error:
        return 'Test failed';
    }
  }
}

class _ResultItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ResultItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
