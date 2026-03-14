import 'dart:js_interop';

import 'package:web/web.dart' as web;

Future<String> saveCsvAndShare(String csv, String filePrefix) async {
  // On web, trigger a file download via the browser
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final fileName = '${filePrefix}_$timestamp.csv';

  final blob = web.Blob(
    [csv.toJS].toJS,
    web.BlobPropertyBag(type: 'text/csv'),
  );

  final url = web.URL.createObjectURL(blob);
  final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
  anchor.href = url;
  anchor.download = fileName;
  anchor.click();
  web.URL.revokeObjectURL(url);

  return fileName;
}

Future<void> platformShareFile(String filePath) async {
  // On web, the file was already downloaded in saveCsvAndShare
}
