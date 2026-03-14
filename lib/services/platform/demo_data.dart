import 'dart:math';

import '../../models/wifi_network.dart';
import '../../models/lan_device.dart';

/// Generates realistic demo data for web platform where native APIs are unavailable
class DemoData {
  DemoData._();

  static final _random = Random(42);

  static List<WiFiNetwork> generateWifiNetworks() {
    final now = DateTime.now();
    return [
      WiFiNetwork(
        ssid: 'HomeWiFi-5G',
        bssid: 'AA:BB:CC:DD:EE:01',
        rssi: -42,
        frequency: 5180,
        channel: 36,
        security: 'WPA3',
        band: '5 GHz',
        timestamp: now,
      ),
      WiFiNetwork(
        ssid: 'HomeWiFi',
        bssid: 'AA:BB:CC:DD:EE:02',
        rssi: -48,
        frequency: 2437,
        channel: 6,
        security: 'WPA2',
        band: '2.4 GHz',
        timestamp: now,
      ),
      WiFiNetwork(
        ssid: 'Neighbor_Net',
        bssid: '11:22:33:44:55:01',
        rssi: -65,
        frequency: 2412,
        channel: 1,
        security: 'WPA2',
        band: '2.4 GHz',
        timestamp: now,
      ),
      WiFiNetwork(
        ssid: 'CoffeeShop_Free',
        bssid: '11:22:33:44:55:02',
        rssi: -72,
        frequency: 2462,
        channel: 11,
        security: 'Open',
        band: '2.4 GHz',
        timestamp: now,
      ),
      WiFiNetwork(
        ssid: 'Office5G',
        bssid: '11:22:33:44:55:03',
        rssi: -55,
        frequency: 5745,
        channel: 149,
        security: 'WPA3',
        band: '5 GHz',
        timestamp: now,
      ),
      WiFiNetwork(
        ssid: 'TP-Link_Guest',
        bssid: '11:22:33:44:55:04',
        rssi: -78,
        frequency: 2437,
        channel: 6,
        security: 'WPA2',
        band: '2.4 GHz',
        timestamp: now,
      ),
      WiFiNetwork(
        ssid: '',
        bssid: '11:22:33:44:55:05',
        rssi: -81,
        frequency: 2422,
        channel: 3,
        security: 'WPA2',
        band: '2.4 GHz',
        timestamp: now,
      ),
      WiFiNetwork(
        ssid: 'ASUS_5G_Gaming',
        bssid: '11:22:33:44:55:06',
        rssi: -60,
        frequency: 5200,
        channel: 40,
        security: 'WPA3',
        band: '5 GHz',
        timestamp: now,
      ),
      WiFiNetwork(
        ssid: 'AndroidAP',
        bssid: '11:22:33:44:55:07',
        rssi: -69,
        frequency: 2447,
        channel: 8,
        security: 'WPA2',
        band: '2.4 GHz',
        timestamp: now,
      ),
      WiFiNetwork(
        ssid: 'Linksys_Office',
        bssid: '11:22:33:44:55:08',
        rssi: -74,
        frequency: 2412,
        channel: 1,
        security: 'WPA2',
        band: '2.4 GHz',
        timestamp: now,
      ),
      WiFiNetwork(
        ssid: 'SmartHome_IoT',
        bssid: '11:22:33:44:55:09',
        rssi: -58,
        frequency: 2462,
        channel: 11,
        security: 'WPA2',
        band: '2.4 GHz',
        timestamp: now,
      ),
      WiFiNetwork(
        ssid: 'NetGear-5G-Pro',
        bssid: '11:22:33:44:55:0A',
        rssi: -63,
        frequency: 5260,
        channel: 52,
        security: 'WPA3',
        band: '5 GHz',
        timestamp: now,
      ),
    ];
  }

  /// Add slight RSSI variation to simulate real-time changes
  static List<WiFiNetwork> refreshNetworks(List<WiFiNetwork> networks) {
    return networks.map((n) {
      final variation = _random.nextInt(7) - 3; // -3 to +3
      return WiFiNetwork(
        ssid: n.ssid,
        bssid: n.bssid,
        rssi: (n.rssi + variation).clamp(-100, -20),
        frequency: n.frequency,
        channel: n.channel,
        security: n.security,
        band: n.band,
        timestamp: DateTime.now(),
      );
    }).toList();
  }

  static List<LanDevice> generateLanDevices() {
    final now = DateTime.now();
    return [
      LanDevice(ip: '192.168.1.1', hostname: 'router.local', discoveredAt: now),
      LanDevice(ip: '192.168.1.10', hostname: 'MacBook-Pro', discoveredAt: now),
      LanDevice(ip: '192.168.1.15', hostname: 'iPhone-14', discoveredAt: now),
      LanDevice(ip: '192.168.1.20', hostname: 'Samsung-TV', discoveredAt: now),
      LanDevice(ip: '192.168.1.25', hostname: 'Chromecast', discoveredAt: now),
      LanDevice(ip: '192.168.1.30', hostname: 'PS5', discoveredAt: now),
      LanDevice(ip: '192.168.1.42', hostname: 'RPi-HomeAssistant', discoveredAt: now),
      LanDevice(ip: '192.168.1.100', hostname: 'Printer-HP', discoveredAt: now),
    ];
  }

  static double generateDownloadSpeed() => 85.0 + _random.nextDouble() * 40;
  static double generateUploadSpeed() => 25.0 + _random.nextDouble() * 20;
  static double generatePing() => 8.0 + _random.nextDouble() * 15;
  static double generatePacketLoss() =>
      _random.nextDouble() < 0.8 ? 0.0 : _random.nextDouble() * 2;
}
