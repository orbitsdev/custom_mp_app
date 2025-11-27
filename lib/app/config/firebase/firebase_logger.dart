import 'dart:developer' as developer;

class FirebaseLogger {
  static final StringBuffer _buffer = StringBuffer();
  static bool _isGroupActive = false;

  static void group(String title) {
    _isGroupActive = true;
    _buffer.clear();
    _buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    _buffer.writeln('🔥 $title');
    _buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  static void log(String message) {
    if (_isGroupActive) {
      _buffer.writeln('  $message');
    } else {
      developer.log(message, name: 'Firebase');
    }
  }

  static void endGroup() {
    if (_isGroupActive) {
      _buffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      developer.log(_buffer.toString(), name: 'Firebase');
      _buffer.clear();
      _isGroupActive = false;
    }
  }
}
