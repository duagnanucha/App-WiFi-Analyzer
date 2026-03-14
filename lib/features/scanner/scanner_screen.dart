import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/ad_banner_widget.dart';
import '../../providers/lan_scanner_provider.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scanner = context.watch<LanScannerProvider>();
    final theme = Theme.of(context);

    return Column(
      children: [
        // Scan control
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: scanner.isScanning
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Scanning network...',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: scanner.progress < 1
                                ? scanner.progress
                                : null,
                          ),
                        ],
                      )
                    : Text(
                        '${scanner.devices.length} devices found',
                        style: theme.textTheme.titleMedium,
                      ),
              ),
              const SizedBox(width: 16),
              FilledButton.icon(
                onPressed: scanner.isScanning
                    ? () => scanner.stopScan()
                    : () => scanner.startScan(),
                icon: Icon(scanner.isScanning ? Icons.stop : Icons.search),
                label: Text(scanner.isScanning ? 'Stop' : 'Scan'),
              ),
            ],
          ),
        ),
        // Device list
        Expanded(
          child: scanner.devices.isEmpty && !scanner.isScanning
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.devices,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      const Text('No devices found'),
                      const SizedBox(height: 8),
                      const Text('Tap Scan to discover devices on your network'),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: scanner.devices.length,
                  itemBuilder: (context, index) {
                    final device = scanner.devices[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          Icons.devices,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      title: Text(device.displayName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('IP: ${device.ip}'),
                          if (device.macAddress != null)
                            Text('MAC: ${device.macAddress}'),
                        ],
                      ),
                    );
                  },
                ),
        ),
        const AdBannerWidget(),
      ],
    );
  }
}
