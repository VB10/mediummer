import 'package:mediummerflutter/feature/messaging/mediator/messaging_mediator.dart';
import 'package:mediummerflutter/feature/messaging/models/message.dart';

/// MessageLogger is a colleague that logs all messaging activities
/// It communicates with other components through the mediator
class MessageLogger {
  MessageLogger(this._mediator) {
    // Register with the mediator
    _mediator.registerColleague(this);
  }
  final MessagingMediator _mediator;
  final List<String> _logHistory = [];
  final List<Message> _messageHistory = [];

  /// Log a general event
  void logEvent(String event) {
    final logEntry = '[${DateTime.now()}] EVENT: $event';
    _logHistory.add(logEntry);

    print('MessageLogger: $logEntry');

    // Keep only last 200 log entries
    if (_logHistory.length > 200) {
      _logHistory.removeAt(0);
    }
  }

  /// Log a message
  void logMessage(Message message) {
    final logEntry =
        '[${DateTime.now()}] MESSAGE: ${message.sender.name} -> ${message.content}';
    _logHistory.add(logEntry);

    // Store message in history
    _messageHistory.add(message);

    print('MessageLogger: $logEntry');

    // Keep only last 200 log entries and messages
    if (_logHistory.length > 200) {
      _logHistory.removeAt(0);
    }

    if (_messageHistory.length > 200) {
      _messageHistory.removeAt(0);
    }
  }

  /// Log an error
  void logError(String error, [Object? details]) {
    final logEntry =
        '[${DateTime.now()}] ERROR: $error${details != null ? ' - $details' : ''}';
    _logHistory.add(logEntry);

    print('MessageLogger: $logEntry');

    if (_logHistory.length > 200) {
      _logHistory.removeAt(0);
    }
  }

  /// Log a warning
  void logWarning(String warning) {
    final logEntry = '[${DateTime.now()}] WARNING: $warning';
    _logHistory.add(logEntry);

    print('MessageLogger: $logEntry');

    if (_logHistory.length > 200) {
      _logHistory.removeAt(0);
    }
  }

  /// Log user activity
  void logUserActivity(String userId, String activity) {
    final logEntry =
        '[${DateTime.now()}] USER_ACTIVITY: User $userId - $activity';
    _logHistory.add(logEntry);

    print('MessageLogger: $logEntry');

    if (_logHistory.length > 200) {
      _logHistory.removeAt(0);
    }
  }

  /// Get log history
  List<String> get logHistory => List.unmodifiable(_logHistory);

  /// Get message history
  List<Message> get messageHistory => List.unmodifiable(_messageHistory);

  /// Search logs by keyword
  List<String> searchLogs(String keyword) {
    return _logHistory
        .where((log) => log.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }

  /// Get logs for a specific time range
  List<String> getLogsInTimeRange(DateTime start, DateTime end) {
    return _logHistory.where((log) {
      // Extract timestamp from log entry [timestamp] ...
      final timestampMatch = RegExp(r'\[(.*?)\]').firstMatch(log);
      if (timestampMatch != null) {
        try {
          final timestamp = DateTime.parse(timestampMatch.group(1)!);
          return timestamp.isAfter(start) && timestamp.isBefore(end);
        } catch (e) {
          return false;
        }
      }
      return false;
    }).toList();
  }

  /// Clear log history
  void clearLogHistory() {
    _logHistory.clear();
    _messageHistory.clear();
  }

  /// Export logs to string (for debugging)
  String exportLogs() {
    return _logHistory.join('\n');
  }

  /// Dispose the logger
  void dispose() {
    _mediator.unregisterColleague(this);
  }
}
