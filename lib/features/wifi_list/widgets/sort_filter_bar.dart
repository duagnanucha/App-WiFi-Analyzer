import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/wifi_provider.dart';

class SortFilterBar extends StatelessWidget {
  const SortFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final wifi = context.watch<WifiProvider>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Band filter chips
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: wifi.bandFilter == WifiBandFilter.all,
                    onSelected: (_) =>
                        wifi.setBandFilter(WifiBandFilter.all),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('2.4 GHz'),
                    selected: wifi.bandFilter == WifiBandFilter.ghz24,
                    onSelected: (_) =>
                        wifi.setBandFilter(WifiBandFilter.ghz24),
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('5 GHz'),
                    selected: wifi.bandFilter == WifiBandFilter.ghz5,
                    onSelected: (_) =>
                        wifi.setBandFilter(WifiBandFilter.ghz5),
                  ),
                ],
              ),
            ),
          ),
          // Sort menu
          PopupMenuButton<WifiSortMode>(
            icon: const Icon(Icons.sort),
            onSelected: wifi.setSortMode,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: WifiSortMode.signal,
                child: Row(
                  children: [
                    if (wifi.sortMode == WifiSortMode.signal)
                      Icon(Icons.check, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Sort by Signal'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: WifiSortMode.name,
                child: Row(
                  children: [
                    if (wifi.sortMode == WifiSortMode.name)
                      Icon(Icons.check, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Sort by Name'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: WifiSortMode.channel,
                child: Row(
                  children: [
                    if (wifi.sortMode == WifiSortMode.channel)
                      Icon(Icons.check, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Sort by Channel'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
