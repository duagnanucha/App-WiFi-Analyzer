class WiFiConstants {
  WiFiConstants._();

  // 2.4 GHz channel center frequencies (MHz)
  static const Map<int, int> channelFrequency24 = {
    1: 2412,
    2: 2417,
    3: 2422,
    4: 2427,
    5: 2432,
    6: 2437,
    7: 2442,
    8: 2447,
    9: 2452,
    10: 2457,
    11: 2462,
    12: 2467,
    13: 2472,
    14: 2484,
  };

  // 5 GHz channel center frequencies (MHz)
  static const Map<int, int> channelFrequency5 = {
    36: 5180,
    40: 5200,
    44: 5220,
    48: 5240,
    52: 5260,
    56: 5280,
    60: 5300,
    64: 5320,
    100: 5500,
    104: 5520,
    108: 5540,
    112: 5560,
    116: 5580,
    120: 5600,
    124: 5620,
    128: 5640,
    132: 5660,
    136: 5680,
    140: 5700,
    144: 5720,
    149: 5745,
    153: 5765,
    157: 5785,
    161: 5805,
    165: 5825,
  };

  // Non-overlapping channels for 2.4 GHz
  static const List<int> nonOverlapping24 = [1, 6, 11];

  // RSSI quality thresholds (dBm)
  static const int rssiExcellent = -50;
  static const int rssiGood = -60;
  static const int rssiFair = -70;
  static const int rssiWeak = -80;
  // Below -80 = Poor

  // 2.4 GHz channel overlap: each 20MHz channel affects +/- 2 channels
  static const int channelOverlapWidth24 = 2;
}
