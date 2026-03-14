import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<String> saveCsvAndShare(String csv, String filePrefix) async {
  final dir = await getTemporaryDirectory();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final file = File('${dir.path}/${filePrefix}_$timestamp.csv');
  await file.writeAsString(csv);
  return file.path;
}

Future<void> platformShareFile(String filePath) async {
  await Share.shareXFiles([XFile(filePath)]);
}
