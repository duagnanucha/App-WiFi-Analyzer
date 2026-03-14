class NetworkUtils {
  NetworkUtils._();

  /// Extract subnet from IP address (e.g., "192.168.1.105" -> "192.168.1")
  static String getSubnet(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return '192.168.1';
    return '${parts[0]}.${parts[1]}.${parts[2]}';
  }

  /// Validate IP address format
  static bool isValidIp(String ip) {
    final parts = ip.split('.');
    if (parts.length != 4) return false;
    for (final part in parts) {
      final num = int.tryParse(part);
      if (num == null || num < 0 || num > 255) return false;
    }
    return true;
  }
}
