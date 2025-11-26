import 'package:logger/logger.dart';

class FirebaseLogger {
  static final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      colors: true,
    ),
  );

  static void group(String title) {
    _logger.i("===== $title =====");
  }

  static void log(String message) {
    _logger.i(message);
  }

  static void endGroup() {
    _logger.i("===== END =====");
  }
}
