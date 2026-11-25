import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() => integrationDriver(
  responseDataCallback: null,
  onScreenshot: (name, bytes, [_]) async {
    const pngHeader = '\x89PNG\r\n\x1a\n';
    if (name != 'assignment-12.1-contribution' ||
        bytes.length < 1024 ||
        String.fromCharCodes(bytes.take(pngHeader.length)) != pngHeader) {
      return false;
    }
    await File('$name.png').writeAsBytes(bytes);
    return true;
  },
);
