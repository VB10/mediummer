import 'package:flutter/foundation.dart';
import 'package:mediummerflutter/feature/task/commands/task_command.dart';

/// Manages the execution and history of task commands
class TaskCommandManager {
  final List<TaskCommand> _commandHistory = [];
  final List<TaskCommand> _undoHistory = [];
  final _commandLogger = CommandLogger();

  /// Executes a command and adds it to the history
  Future<void> executeCommand(TaskCommand command) async {
    await command.execute();
    _commandHistory.add(command);
    _undoHistory.clear(); // Clear redo history when new command is executed
    _commandLogger.logCommand(command);
  }

  /// Undoes the last executed command
  Future<void> undo() async {
    if (_commandHistory.isEmpty) return;

    final command = _commandHistory.removeLast();
    await command.undo();
    _undoHistory.add(command);
    _commandLogger.logUndo(command);
  }

  /// Redoes the last undone command
  Future<void> redo() async {
    if (_undoHistory.isEmpty) return;

    final command = _undoHistory.removeLast();
    await command.execute();
    _commandHistory.add(command);
    _commandLogger.logRedo(command);
  }

  /// Returns whether there are commands that can be undone
  bool get canUndo => _commandHistory.isNotEmpty;

  /// Returns whether there are commands that can be redone
  bool get canRedo => _undoHistory.isNotEmpty;

  /// Returns the command history
  List<TaskCommand> get commandHistory => List.unmodifiable(_commandHistory);
}

/// Helper class for logging command operations
class CommandLogger {
  void logCommand(TaskCommand command) {
    debugPrint('Executed: ${command.commandDescription}');
  }

  void logUndo(TaskCommand command) {
    debugPrint('Undid: ${command.commandDescription}');
  }

  void logRedo(TaskCommand command) {
    debugPrint('Redid: ${command.commandDescription}');
  }
}
