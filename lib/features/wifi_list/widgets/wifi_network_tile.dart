import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/signal_indicator.dart';
import '../../../models/wifi_network.dart';

class WifiNetworkTile extends StatelessWidget {
  final WiFiNetwork network;
  final bool isConnected;
  final VoidCallback? onTap;

  const WifiNetworkTile({
    super.key,
    required this.network,
    this.isConnected = false,
    this.onTap,
  });

  IconData get _securityIcon {
    if (network.security == 'Open') return Icons.lock_open;
    return Icons.lock;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: SignalIndicator(rssi: network.rssi, size: 32),
      title: Row(
        children: [
          Expanded(
            child: Text(
              network.displayName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isConnected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Connected',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
        ],
      ),
      subtitle: Row(
        children: [
          Text(Formatters.formatRssi(network.rssi)),
          const SizedBox(width: 8),
          Text('CH ${network.channel}'),
          const SizedBox(width: 8),
          Text(network.band),
          const SizedBox(width: 8),
          Icon(_securityIcon, size: 14),
          const SizedBox(width: 2),
          Text(network.security, style: theme.textTheme.bodySmall),
        ],
      ),
      onTap: onTap,
    );
  }
}
