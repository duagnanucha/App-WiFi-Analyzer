import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/utils/wifi_utils.dart';
import '../../../core/widgets/signal_indicator.dart';
import '../../../models/wifi_network.dart';

class WifiDetailSheet extends StatelessWidget {
  final WiFiNetwork network;

  const WifiDetailSheet({super.key, required this.network});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SignalIndicator(rssi: network.rssi, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        network.displayName,
                        style: theme.textTheme.headlineSmall,
                      ),
                      Text(
                        WiFiUtils.rssiToLabel(network.rssi),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _DetailRow('SSID', network.displayName),
            _DetailRow('BSSID', network.bssid),
            _DetailRow('Signal', Formatters.formatRssi(network.rssi)),
            _DetailRow(
              'Quality',
              '${WiFiUtils.rssiToQuality(network.rssi)}%',
            ),
            _DetailRow('Channel', '${network.channel}'),
            _DetailRow(
              'Frequency',
              Formatters.formatFrequency(network.frequency),
            ),
            _DetailRow('Band', network.band),
            _DetailRow('Security', network.security),
          ],
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
