import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/formatters.dart';
import '../../providers/history_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<HistoryProvider>().loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'export_scan':
                  await history.exportScanCsv();
                  break;
                case 'export_speed':
                  await history.exportSpeedCsv();
                  break;
                case 'clear_all':
                  _showClearDialog(context, history);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export_scan',
                child: Text('Export WiFi Scans CSV'),
              ),
              const PopupMenuItem(
                value: 'export_speed',
                child: Text('Export Speed Tests CSV'),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'clear_all',
                child: Text('Clear All History'),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'WiFi Scans'),
            Tab(text: 'Speed Tests'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Scan history
          history.scanHistory.isEmpty
              ? const Center(child: Text('No scan history'))
              : ListView.builder(
                  itemCount: history.scanHistory.length,
                  itemBuilder: (context, index) {
                    final entry = history.scanHistory[index];
                    return ListTile(
                      leading: const Icon(Icons.wifi_find),
                      title: Text(
                          '${entry.totalNetworks} networks found'),
                      subtitle: Text(
                          Formatters.formatDateTime(entry.timestamp)),
                      trailing: entry.connectedSsid != null
                          ? Chip(label: Text(entry.connectedSsid!))
                          : null,
                    );
                  },
                ),
          // Speed test history
          history.speedHistory.isEmpty
              ? const Center(child: Text('No speed test history'))
              : ListView.builder(
                  itemCount: history.speedHistory.length,
                  itemBuilder: (context, index) {
                    final result = history.speedHistory[index];
                    return ListTile(
                      leading: const Icon(Icons.speed),
                      title: Row(
                        children: [
                          Icon(Icons.download, size: 16,
                              color: Colors.green),
                          Text(
                              ' ${Formatters.formatSpeed(result.downloadMbps)}'),
                          const SizedBox(width: 12),
                          Icon(Icons.upload, size: 16,
                              color: Colors.blue),
                          Text(
                              ' ${Formatters.formatSpeed(result.uploadMbps)}'),
                        ],
                      ),
                      subtitle: Text(
                        '${Formatters.formatDateTime(result.timestamp)} '
                        '| Ping: ${Formatters.formatPing(result.pingMs)}',
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context, HistoryProvider history) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text(
            'Are you sure you want to delete all history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              history.clearScanHistory();
              history.clearSpeedHistory();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
