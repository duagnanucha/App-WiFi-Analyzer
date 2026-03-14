import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/ad_banner_widget.dart';
import '../../providers/channel_provider.dart';
import '../../providers/wifi_provider.dart';
import 'widgets/channel_chart.dart';
import 'widgets/recommendation_card.dart';

class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _analyze();
  }

  void _analyze() {
    final wifi = context.read<WifiProvider>();
    context.read<ChannelProvider>().analyze(wifi.allNetworks);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final channel = context.watch<ChannelProvider>();
    final theme = Theme.of(context);

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '2.4 GHz'),
            Tab(text: '5 GHz'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // 2.4 GHz tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (channel.recommendedChannel24 != null)
                      RecommendationCard(
                        channel: channel.recommendedChannel24!,
                        band: '2.4 GHz',
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: ChannelChart(
                        channels: channel.channels24,
                        highlightChannel: channel.recommendedChannel24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Channel list
                    ...channel.channels24
                        .where((c) => c.networkCount > 0)
                        .map((c) => ListTile(
                              leading: CircleAvatar(
                                child: Text('${c.channel}'),
                              ),
                              title: Text('Channel ${c.channel}'),
                              subtitle: Text(
                                '${c.networkCount} network${c.networkCount != 1 ? "s" : ""}',
                              ),
                              trailing: Text(
                                'Score: ${c.congestionScore.toStringAsFixed(0)}',
                                style: theme.textTheme.bodySmall,
                              ),
                            )),
                  ],
                ),
              ),
              // 5 GHz tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (channel.recommendedChannel5 != null)
                      RecommendationCard(
                        channel: channel.recommendedChannel5!,
                        band: '5 GHz',
                      ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 250,
                      child: ChannelChart(
                        channels: channel.channels5,
                        highlightChannel: channel.recommendedChannel5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...channel.channels5
                        .where((c) => c.networkCount > 0)
                        .map((c) => ListTile(
                              leading: CircleAvatar(
                                child: Text('${c.channel}'),
                              ),
                              title: Text('Channel ${c.channel}'),
                              subtitle: Text(
                                '${c.networkCount} network${c.networkCount != 1 ? "s" : ""}',
                              ),
                            )),
                  ],
                ),
              ),
            ],
          ),
        ),
        const AdBannerWidget(),
      ],
    );
  }
}
