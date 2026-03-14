import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final _dateFormat = DateFormat('dd MMM yyyy');
  static final _timeFormat = DateFormat('HH:mm:ss');
  static final _dateTimeFormat = DateFormat('dd MMM yyyy HH:mm');

  static String formatDate(DateTime date) => _dateFormat.format(date);
  static String formatTime(DateTime date) => _timeFormat.format(date);
  static String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

  static String formatSpeed(double mbps) {
    if (mbps >= 1000) return '${(mbps / 1000).toStringAsFixed(1)} Gbps';
    if (mbps >= 100) return '${mbps.toStringAsFixed(0)} Mbps';
    if (mbps >= 10) return '${mbps.toStringAsFixed(1)} Mbps';
    return '${mbps.toStringAsFixed(2)} Mbps';
  }

  static String formatPing(double ms) {
    if (ms < 1) return '<1 ms';
    return '${ms.toStringAsFixed(0)} ms';
  }

  static String formatRssi(int rssi) => '$rssi dBm';

  static String formatFrequency(int freq) => '$freq MHz';

  static String formatPacketLoss(double loss) =>
      '${loss.toStringAsFixed(1)}%';
}
