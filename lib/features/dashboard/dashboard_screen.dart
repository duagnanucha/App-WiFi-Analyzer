import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/formatters.dart';
import '../../core/utils/wifi_utils.dart';
import '../../core/widgets/ad_banner_widget.dart';
import '../../core/widgets/signal_indicator.dart';
import '../../providers/wifi_provider.dart';
import 'widgets/signal_gauge.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<WifiProvider>();
    provider.startListening();
    provider.startScan();
  }

  @override
  Widget build(BuildContext context) {
    final wifi = context.watch<WifiProvider>();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Connected Network Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        wifi.connectedSsid != null
                            ? Icons.wifi
                            : Icons.wifi_off,
                        color: wifi.connectedSsid != null
                            ? theme.colorScheme.primary
                            : theme.colorScheme.error,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          wifi.connectedSsid ?? 'Not Connected',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      if (wifi.connectedRssi != null)
                        SignalIndicator(rssi: wifi.connectedRssi!),
                    ],
                  ),
                  if (wifi.connectedBssid != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'BSSID: ${wifi.connectedBssid}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  if (wifi.wifiIp != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'IP: ${wifi.wifiIp}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Signal Strength Gauge
          if (wifi.connectedRssi != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Signal Strength',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: SignalGauge(rssi: wifi.connectedRssi!),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Formatters.formatRssi(wifi.connectedRssi!),
                      style: theme.textTheme.headlineMedium,
                    ),
                    Text(
                      WiFiUtils.rssiToLabel(wifi.connectedRssi!),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Quick Stats
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Stats',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        icon: Icons.wifi,
                        label: 'Networks',
                        value: '${wifi.allNetworks.length}',
                      ),
                      _StatItem(
                        icon: Icons.signal_cellular_alt,
                        label: '2.4 GHz',
                        value:
                            '${wifi.allNetworks.where((n) => n.band == "2.4 GHz").length}',
                      ),
                      _StatItem(
                        icon: Icons.signal_cellular_alt,
                        label: '5 GHz',
                        value:
                            '${wifi.allNetworks.where((n) => n.band == "5 GHz").length}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const AdBannerWidget(),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleLarge),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
