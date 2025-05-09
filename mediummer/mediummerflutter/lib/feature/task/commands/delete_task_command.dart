import 'package:mediummerflutter/feature/task/commands/task_command.dart';
import 'package:mediummerflutter/feature/task/models/task.dart';
import 'package:mediummerflutter/feature/task/repositories/task_repository.dart';

/// Command for deleting a task
class DeleteTaskCommand extends BaseTaskCommand {
  DeleteTaskCommand({
    required super.taskId,
    required TaskRepository repository,
    super.timestamp,
  }) : _repository = repository;
  final TaskRepository _repository;
  Task? _deletedTask;

  @override
  Future<void> execute() async {
    _deletedTask = await _repository.getTaskById(taskId);
    if (_deletedTask != null) {
      await _repository.deleteTask(taskId);
    }
  }

  @override
  Future<void> undo() async {
    if (_deletedTask != null) {
      await _repository.saveTask(_deletedTask!);
    }
  }

  @override
  String get commandDescription =>
      'Delete task: ${_deletedTask?.title ?? taskId}';
}
