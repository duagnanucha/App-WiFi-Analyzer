import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Theme
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            subtitle: Text(_themeName(settings.settings.themeModeIndex)),
            trailing: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, icon: Icon(Icons.phone_android)),
                ButtonSegment(value: 1, icon: Icon(Icons.light_mode)),
                ButtonSegment(value: 2, icon: Icon(Icons.dark_mode)),
              ],
              selected: {settings.settings.themeModeIndex},
              onSelectionChanged: (values) =>
                  settings.setThemeMode(values.first),
            ),
          ),
          const Divider(),

          // Language
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(_languageName(settings.settings.languageCode)),
            trailing: DropdownButton<String>(
              value: settings.settings.languageCode,
              onChanged: (value) {
                if (value != null) settings.setLanguage(value);
              },
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'th', child: Text('ไทย')),
              ],
            ),
          ),
          const Divider(),

          // Pro upgrade
          if (!settings.isPro)
            Card(
              margin: const EdgeInsets.all(16),
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Upgrade to Pro',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Remove all ads and unlock premium features',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () {
                        // TODO: Integrate in-app purchase
                        // For now, just toggle pro status for testing
                        settings.setPro(true);
                      },
                      child: const Text('Upgrade'),
                    ),
                  ],
                ),
              ),
            ),
          if (settings.isPro)
            const ListTile(
              leading: Icon(Icons.star, color: Colors.amber),
              title: Text('Pro User'),
              subtitle: Text('All ads removed'),
            ),

          const Divider(),

          // About
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            subtitle: const Text('WiFi Analyzer Pro v1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'WiFi Analyzer Pro',
                applicationVersion: '1.0.0',
                applicationLegalese:
                    'Scan, analyze, and optimize your WiFi network.',
              );
            },
          ),
        ],
      ),
    );
  }

  String _themeName(int index) {
    switch (index) {
      case 1:
        return 'Light';
      case 2:
        return 'Dark';
      default:
        return 'System';
    }
  }

  String _languageName(String code) {
    switch (code) {
      case 'th':
        return 'ไทย';
      default:
        return 'English';
    }
  }
}
