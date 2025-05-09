import 'package:mediummerflutter/feature/task/commands/task_command.dart';
import 'package:mediummerflutter/feature/task/models/task.dart';
import 'package:mediummerflutter/feature/task/repositories/task_repository.dart';

/// Command for creating a new task
class CreateTaskCommand extends BaseTaskCommand {
  CreateTaskCommand({
    required super.taskId,
    required this.title,
    required this.description,
    required TaskRepository repository,
    super.timestamp,
  }) : _repository = repository;
  final TaskRepository _repository;
  final String title;
  @override
  final String description;
  Task? _createdTask;

  @override
  Future<void> execute() async {
    final task = Task(
      id: taskId,
      title: title,
      description: description,
      createdAt: timestamp,
    );
    await _repository.saveTask(task);
    _createdTask = task;
  }

  @override
  Future<void> undo() async {
    if (_createdTask != null) {
      await _repository.deleteTask(taskId);
      _createdTask = null;
    }
  }

  @override
  String get commandDescription => 'Create task: $title';
}
