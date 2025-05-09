import 'package:flutter/foundation.dart';
import 'package:mediummerflutter/feature/task/commands/create_task_command.dart';
import 'package:mediummerflutter/feature/task/commands/delete_task_command.dart';
import 'package:mediummerflutter/feature/task/commands/task_command_manager.dart';
import 'package:mediummerflutter/feature/task/commands/update_task_command.dart';
import 'package:mediummerflutter/feature/task/models/task.dart';
import 'package:mediummerflutter/feature/task/repositories/task_repository.dart';

/// ViewModel for managing tasks in the UI
class TaskViewModel extends ChangeNotifier {
  TaskViewModel({
    required TaskRepository repository,
    required TaskCommandManager commandManager,
  })  : _repository = repository,
        _commandManager = commandManager;
  final TaskRepository _repository;
  final TaskCommandManager _commandManager;
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get isLoading => _isLoading;
  bool get canUndo => _commandManager.canUndo;
  bool get canRedo => _commandManager.canRedo;

  /// Loads all tasks from the repository
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tasks = await _repository.getAllTasks();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Creates a new task
  Future<void> createTask(String title, String description) async {
    final taskId = DateTime.now().millisecondsSinceEpoch.toString();
    final command = CreateTaskCommand(
      taskId: taskId,
      title: title,
      description: description,
      repository: _repository,
    );

    await _commandManager.executeCommand(command);
    await loadTasks();
  }

  /// Updates an existing task
  Future<void> updateTask(Task task) async {
    final command = UpdateTaskCommand(
      taskId: task.id,
      newTask: task,
      repository: _repository,
    );

    await _commandManager.executeCommand(command);
    await loadTasks();
  }

  /// Deletes a task
  Future<void> deleteTask(String taskId) async {
    final command = DeleteTaskCommand(taskId: taskId, repository: _repository);

    await _commandManager.executeCommand(command);
    await loadTasks();
  }

  /// Undoes the last command
  Future<void> undo() async {
    await _commandManager.undo();
    await loadTasks();
  }

  /// Redoes the last undone command
  Future<void> redo() async {
    await _commandManager.redo();
    await loadTasks();
  }
}
