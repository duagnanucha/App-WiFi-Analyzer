import '../constants/wifi_constants.dart';

class WiFiUtils {
  WiFiUtils._();

  /// Convert frequency (MHz) to channel number
  static int frequencyToChannel(int frequency) {
    // 2.4 GHz band
    if (frequency >= 2412 && frequency <= 2484) {
      if (frequency == 2484) return 14;
      return ((frequency - 2412) / 5).round() + 1;
    }

    // 5 GHz band
    if (frequency >= 5180 && frequency <= 5825) {
      return ((frequency - 5000) / 5).round();
    }

    // 6 GHz band (Wi-Fi 6E)
    if (frequency >= 5955 && frequency <= 7115) {
      return ((frequency - 5950) / 5).round();
    }

    return 0;
  }

  /// Determine band from frequency
  static String frequencyToBand(int frequency) {
    if (frequency >= 2412 && frequency <= 2484) return '2.4 GHz';
    if (frequency >= 5180 && frequency <= 5825) return '5 GHz';
    if (frequency >= 5955 && frequency <= 7115) return '6 GHz';
    return 'Unknown';
  }

  /// Check if frequency is in 2.4 GHz band
  static bool is24GHz(int frequency) =>
      frequency >= 2412 && frequency <= 2484;

  /// Check if frequency is in 5 GHz band
  static bool is5GHz(int frequency) =>
      frequency >= 5180 && frequency <= 5825;

  /// Convert RSSI to signal quality percentage (0-100)
  static int rssiToQuality(int rssi) {
    if (rssi >= -50) return 100;
    if (rssi <= -100) return 0;
    return 2 * (rssi + 100);
  }

  /// Get signal quality label from RSSI
  static String rssiToLabel(int rssi) {
    if (rssi >= WiFiConstants.rssiExcellent) return 'Excellent';
    if (rssi >= WiFiConstants.rssiGood) return 'Good';
    if (rssi >= WiFiConstants.rssiFair) return 'Fair';
    if (rssi >= WiFiConstants.rssiWeak) return 'Weak';
    return 'Poor';
  }

  /// Parse security type from capabilities string
  static String parseSecurityType(String capabilities) {
    if (capabilities.contains('WPA3')) return 'WPA3';
    if (capabilities.contains('WPA2')) return 'WPA2';
    if (capabilities.contains('WPA')) return 'WPA';
    if (capabilities.contains('WEP')) return 'WEP';
    if (capabilities.contains('ESS') && !capabilities.contains('WPA') &&
        !capabilities.contains('WEP')) return 'Open';
    return 'Unknown';
  }

  /// Get channels affected by a network on a given 2.4 GHz channel
  /// (each channel overlaps +/- 2 channels)
  static List<int> getOverlappingChannels24(int channel) {
    final result = <int>[];
    for (int i = channel - WiFiConstants.channelOverlapWidth24;
        i <= channel + WiFiConstants.channelOverlapWidth24;
        i++) {
      if (i >= 1 && i <= 14) result.add(i);
    }
    return result;
  }

  /// Calculate congestion score for a channel
  /// Higher score = more congested
  static double calculateCongestionScore(int channel, List<int> networkRssis,
      List<int> networkChannels, bool is24Ghz) {
    double score = 0;
    for (int i = 0; i < networkRssis.length; i++) {
      if (is24Ghz) {
        final overlapping = getOverlappingChannels24(networkChannels[i]);
        if (overlapping.contains(channel)) {
          // Closer channels contribute more to interference
          final distance = (networkChannels[i] - channel).abs();
          final overlapFactor = 1.0 - (distance / 5.0);
          score += (100 + networkRssis[i]) * overlapFactor;
        }
      } else {
        // 5 GHz channels don't overlap (when using same channel width)
        if (networkChannels[i] == channel) {
          score += (100 + networkRssis[i]).toDouble();
        }
      }
    }
    return score;
  }
}
