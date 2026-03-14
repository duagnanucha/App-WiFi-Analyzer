class ChannelInfo {
  final int channel;
  final int frequency;
  final String band;
  final int networkCount;
  final double avgRssi;
  final double congestionScore;

  const ChannelInfo({
    required this.channel,
    required this.frequency,
    required this.band,
    required this.networkCount,
    required this.avgRssi,
    required this.congestionScore,
  });
}
