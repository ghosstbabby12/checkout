import 'dart:developer' as developer;

import 'package:logging/logging.dart';

/// Shared logger for the app.
final Logger appLogger = Logger('checkout');

/// Initialize logging for the application. Call early in `main()`.
void initLogging() {
  // Accept all records — the listener decides what to do with them.
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // Forward to the platform's developer log so logs appear in device logcat / Xcode.
    try {
      developer.log(
        '[${record.level.name}] ${record.loggerName}: ${record.message}',
        name: 'checkout',
        level: record.level.value,
      );
      if (record.error != null) {
        developer.log(
          'Error: ${record.error}',
          name: 'checkout',
          level: record.level.value,
        );
      }
      if (record.stackTrace != null) {
        developer.log(
          'Stack: ${record.stackTrace}',
          name: 'checkout',
          level: record.level.value,
        );
      }
    } catch (_) {}
  });
}
