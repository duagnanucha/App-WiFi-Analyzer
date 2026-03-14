import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/permission_provider.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PermissionProvider>();
    final isPermanent = provider.state == PermissionState.permanentlyDenied;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_find,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Permission Required',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'WiFi Analyzer needs permission to scan nearby WiFi networks. '
                'On Android, this requires location or nearby devices permission.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your location data is never collected or shared. '
                'The permission is only used for WiFi scanning.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              if (isPermanent) ...[
                Text(
                  'Permission is permanently denied. '
                  'Please enable it in app settings.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => provider.openSettings(),
                  icon: const Icon(Icons.settings),
                  label: const Text('Open Settings'),
                ),
              ] else
                FilledButton.icon(
                  onPressed: () => provider.requestPermission(),
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Grant Permission'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
