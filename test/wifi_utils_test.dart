import 'package:flutter_test/flutter_test.dart';
import 'package:wifi_analyzer_pro/core/utils/wifi_utils.dart';

void main() {
  group('WiFiUtils.frequencyToChannel', () {
    test('2.4 GHz channels', () {
      expect(WiFiUtils.frequencyToChannel(2412), 1);
      expect(WiFiUtils.frequencyToChannel(2437), 6);
      expect(WiFiUtils.frequencyToChannel(2462), 11);
      expect(WiFiUtils.frequencyToChannel(2484), 14);
    });

    test('5 GHz channels', () {
      expect(WiFiUtils.frequencyToChannel(5180), 36);
      expect(WiFiUtils.frequencyToChannel(5200), 40);
      expect(WiFiUtils.frequencyToChannel(5745), 149);
      expect(WiFiUtils.frequencyToChannel(5825), 165);
    });

    test('unknown frequency returns 0', () {
      expect(WiFiUtils.frequencyToChannel(0), 0);
      expect(WiFiUtils.frequencyToChannel(1000), 0);
    });
  });

  group('WiFiUtils.frequencyToBand', () {
    test('identifies 2.4 GHz', () {
      expect(WiFiUtils.frequencyToBand(2412), '2.4 GHz');
      expect(WiFiUtils.frequencyToBand(2484), '2.4 GHz');
    });

    test('identifies 5 GHz', () {
      expect(WiFiUtils.frequencyToBand(5180), '5 GHz');
      expect(WiFiUtils.frequencyToBand(5825), '5 GHz');
    });

    test('unknown frequency', () {
      expect(WiFiUtils.frequencyToBand(0), 'Unknown');
    });
  });

  group('WiFiUtils.rssiToQuality', () {
    test('converts RSSI to percentage', () {
      expect(WiFiUtils.rssiToQuality(-50), 100);
      expect(WiFiUtils.rssiToQuality(-100), 0);
      expect(WiFiUtils.rssiToQuality(-75), 50);
    });

    test('clamps extreme values', () {
      expect(WiFiUtils.rssiToQuality(-30), 100);
      expect(WiFiUtils.rssiToQuality(-110), 0);
    });
  });

  group('WiFiUtils.rssiToLabel', () {
    test('returns correct labels', () {
      expect(WiFiUtils.rssiToLabel(-40), 'Excellent');
      expect(WiFiUtils.rssiToLabel(-55), 'Good');
      expect(WiFiUtils.rssiToLabel(-65), 'Fair');
      expect(WiFiUtils.rssiToLabel(-75), 'Weak');
      expect(WiFiUtils.rssiToLabel(-90), 'Poor');
    });
  });

  group('WiFiUtils.parseSecurityType', () {
    test('parses security types', () {
      expect(WiFiUtils.parseSecurityType('[WPA2-PSK-CCMP][ESS]'), 'WPA2');
      expect(WiFiUtils.parseSecurityType('[WPA3-SAE][ESS]'), 'WPA3');
      expect(WiFiUtils.parseSecurityType('[WPA-PSK-TKIP][ESS]'), 'WPA');
      expect(WiFiUtils.parseSecurityType('[WEP][ESS]'), 'WEP');
      expect(WiFiUtils.parseSecurityType('[ESS]'), 'Open');
    });
  });

  group('WiFiUtils.getOverlappingChannels24', () {
    test('returns correct overlapping channels', () {
      expect(WiFiUtils.getOverlappingChannels24(6), [4, 5, 6, 7, 8]);
      expect(WiFiUtils.getOverlappingChannels24(1), [1, 2, 3]);
      expect(WiFiUtils.getOverlappingChannels24(11), [9, 10, 11, 12, 13]);
    });
  });

  group('WiFiUtils.calculateCongestionScore', () {
    test('empty networks gives zero congestion', () {
      expect(
        WiFiUtils.calculateCongestionScore(6, [], [], true),
        0,
      );
    });

    test('network on same channel contributes to congestion', () {
      final score = WiFiUtils.calculateCongestionScore(
        6,
        [-50],
        [6],
        true,
      );
      expect(score, greaterThan(0));
    });

    test('5 GHz only counts exact channel match', () {
      final scoreSame = WiFiUtils.calculateCongestionScore(
        36,
        [-50],
        [36],
        false,
      );
      final scoreDiff = WiFiUtils.calculateCongestionScore(
        36,
        [-50],
        [40],
        false,
      );
      expect(scoreSame, greaterThan(0));
      expect(scoreDiff, 0);
    });
  });
}
