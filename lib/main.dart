import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/ad_provider.dart';
import 'providers/channel_provider.dart';
import 'providers/history_provider.dart';
import 'providers/lan_scanner_provider.dart';
import 'providers/permission_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/speed_test_provider.dart';
import 'providers/wifi_provider.dart';
import 'services/ad_service.dart';
import 'services/export_service.dart';
import 'services/lan_scan_service.dart';
import 'services/network_info_service.dart';
import 'services/permission_service.dart';
import 'services/ping_service.dart';
import 'services/speed_test_service.dart';
import 'services/storage_service.dart';
import 'services/wifi_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  final storageService = StorageService();
  await storageService.initialize();

  // Initialize services
  final adService = AdService();
  final permissionService = PermissionService();
  final wifiService = WifiService();
  final networkInfoService = NetworkInfoService();
  final lanScanService = LanScanService();
  final speedTestService = SpeedTestService();
  final pingService = PingService();
  final exportService = ExportService();

  // Initialize ads
  await adService.initialize();
  await adService.loadInterstitial();

  runApp(
    MultiProvider(
      providers: [
        // Services (available for direct injection)
        Provider<AdService>.value(value: adService),
        Provider<StorageService>.value(value: storageService),

        // Providers
        ChangeNotifierProvider(
          create: (_) => PermissionProvider(permissionService),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(storageService, adService),
        ),
        ChangeNotifierProvider(
          create: (_) => WifiProvider(wifiService, networkInfoService),
        ),
        ChangeNotifierProvider(
          create: (_) => ChannelProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              LanScannerProvider(lanScanService, networkInfoService),
        ),
        ChangeNotifierProvider(
          create: (_) => SpeedTestProvider(
            speedTestService,
            pingService,
            storageService,
            adService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryProvider(storageService, exportService),
        ),
        ChangeNotifierProvider(
          create: (_) => AdProvider(adService),
        ),
      ],
      child: const WifiAnalyzerApp(),
    ),
  );
}
