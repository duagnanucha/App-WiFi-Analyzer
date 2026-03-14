import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';

/// Ad banner widget - shows nothing on web (AdMob not supported)
class AdBannerWidget extends StatelessWidget {
  const AdBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) return const SizedBox.shrink();

    final isPro = context.watch<SettingsProvider>().isPro;
    if (isPro) return const SizedBox.shrink();

    // On mobile, ads would be loaded here
    // For now, return a placeholder that the mobile build will handle
    return const SizedBox.shrink();
  }
}
