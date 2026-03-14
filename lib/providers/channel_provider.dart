import 'package:flutter/material.dart';

import '../core/constants/wifi_constants.dart';
import '../core/utils/wifi_utils.dart';
import '../models/channel_info.dart';
import '../models/wifi_network.dart';

class ChannelProvider extends ChangeNotifier {
  List<ChannelInfo> _channels24 = [];
  List<ChannelInfo> get channels24 => _channels24;

  List<ChannelInfo> _channels5 = [];
  List<ChannelInfo> get channels5 => _channels5;

  int? _recommendedChannel24;
  int? get recommendedChannel24 => _recommendedChannel24;

  int? _recommendedChannel5;
  int? get recommendedChannel5 => _recommendedChannel5;

  /// Analyze channels from scanned networks
  void analyze(List<WiFiNetwork> networks) {
    _analyzeband24(networks.where((n) => n.band == '2.4 GHz').toList());
    _analyzeBand5(networks.where((n) => n.band == '5 GHz').toList());
    notifyListeners();
  }

  void _analyzeband24(List<WiFiNetwork> networks) {
    final channels = <int, List<WiFiNetwork>>{};
    for (int ch = 1; ch <= 14; ch++) {
      channels[ch] = [];
    }

    for (final network in networks) {
      if (channels.containsKey(network.channel)) {
        channels[network.channel]!.add(network);
      }
    }

    final rssis = networks.map((n) => n.rssi).toList();
    final networkChannels = networks.map((n) => n.channel).toList();

    _channels24 = channels.entries.map((e) {
      final ch = e.key;
      final nets = e.value;
      final avgRssi = nets.isEmpty
          ? -100.0
          : nets.map((n) => n.rssi).reduce((a, b) => a + b) / nets.length;
      final congestion = WiFiUtils.calculateCongestionScore(
        ch,
        rssis,
        networkChannels,
        true,
      );
      return ChannelInfo(
        channel: ch,
        frequency: WiFiConstants.channelFrequency24[ch] ?? 0,
        band: '2.4 GHz',
        networkCount: nets.length,
        avgRssi: avgRssi,
        congestionScore: congestion,
      );
    }).toList();

    // Recommend from non-overlapping channels {1, 6, 11}
    final nonOverlapping = _channels24
        .where((c) => WiFiConstants.nonOverlapping24.contains(c.channel))
        .toList();
    if (nonOverlapping.isNotEmpty) {
      nonOverlapping
          .sort((a, b) => a.congestionScore.compareTo(b.congestionScore));
      _recommendedChannel24 = nonOverlapping.first.channel;
    }
  }

  void _analyzeBand5(List<WiFiNetwork> networks) {
    final channels = <int, List<WiFiNetwork>>{};
    for (final entry in WiFiConstants.channelFrequency5.entries) {
      channels[entry.key] = [];
    }

    for (final network in networks) {
      if (channels.containsKey(network.channel)) {
        channels[network.channel]!.add(network);
      }
    }

    _channels5 = channels.entries.map((e) {
      final ch = e.key;
      final nets = e.value;
      final avgRssi = nets.isEmpty
          ? -100.0
          : nets.map((n) => n.rssi).reduce((a, b) => a + b) / nets.length;
      return ChannelInfo(
        channel: ch,
        frequency: WiFiConstants.channelFrequency5[ch] ?? 0,
        band: '5 GHz',
        networkCount: nets.length,
        avgRssi: avgRssi,
        congestionScore: nets.length.toDouble(),
      );
    }).toList();

    // 5 GHz: recommend channel with fewest networks
    if (_channels5.isNotEmpty) {
      final sorted = List<ChannelInfo>.from(_channels5)
        ..sort((a, b) => a.networkCount.compareTo(b.networkCount));
      _recommendedChannel5 = sorted.first.channel;
    }
  }
}
