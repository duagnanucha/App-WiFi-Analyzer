import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/ad_banner_widget.dart';
import '../../providers/wifi_provider.dart';
import 'widgets/wifi_network_tile.dart';
import 'widgets/wifi_detail_sheet.dart';
import 'widgets/sort_filter_bar.dart';

class WifiListScreen extends StatelessWidget {
  const WifiListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wifi = context.watch<WifiProvider>();

    return Column(
      children: [
        const SortFilterBar(),
        Expanded(
          child: wifi.isScanning && wifi.networks.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : wifi.networks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.wifi_off,
                            size: 64,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          const Text('No networks found'),
                          const SizedBox(height: 16),
                          FilledButton.icon(
                            onPressed: () => wifi.startScan(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Scan Now'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => wifi.startScan(),
                      child: ListView.builder(
                        itemCount: wifi.networks.length,
                        itemBuilder: (context, index) {
                          final network = wifi.networks[index];
                          return WifiNetworkTile(
                            network: network,
                            isConnected: network.bssid.toLowerCase() ==
                                wifi.connectedBssid?.toLowerCase(),
                            onTap: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) =>
                                  WifiDetailSheet(network: network),
                            ),
                          );
                        },
                      ),
                    ),
        ),
        const AdBannerWidget(),
      ],
    );
  }
}
