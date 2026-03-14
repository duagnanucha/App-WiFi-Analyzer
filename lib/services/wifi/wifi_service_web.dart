import 'dart:async';

import '../../models/wifi_network.dart';
import '../platform/demo_data.dart';
import '../wifi_service.dart';

class WifiServiceWeb implements WifiService {
  List<WiFiNetwork> _networks = [];
  final _controller = StreamController<List<WiFiNetwork>>.broadcast();

  @override
  Future<bool> canScan() async => true;

  @override
  Future<bool> startScan() async {
    if (_networks.isEmpty) {
      _networks = DemoData.generateWifiNetworks();
    } else {
      _networks = DemoData.refreshNetworks(_networks);
    }
    _controller.add(_networks);
    return true;
  }

  @override
  Future<List<WiFiNetwork>> getScannedNetworks() async {
    if (_networks.isEmpty) {
      _networks = DemoData.generateWifiNetworks();
    }
    return _networks;
  }

  @override
  Stream<List<WiFiNetwork>> get onResultsAvailable => _controller.stream;
}
