/// Base interface for all task-related commands
abstract class TaskCommand {
  /// Executes the command
  Future<void> execute();

  /// Undoes the command
  Future<void> undo();

  /// Returns a description of the command for logging
  String get commandDescription;
}

/// Base class for task commands with common functionality
abstract class BaseTaskCommand implements TaskCommand {
  BaseTaskCommand({required this.taskId, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
  final String taskId;
  final DateTime timestamp;

  @override
  String get commandDescription =>
      '$runtimeType for task $taskId at $timestamp';
}


/// 
/// 03:00
/// 05:20
/// 09:00 markownui
/// 12:00 property warpper
/// 17:00 pluto grid
/// 27:00 command pattern
/// 31:20 keypath
/// the end tCA