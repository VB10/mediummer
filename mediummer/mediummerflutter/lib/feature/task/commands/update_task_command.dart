import 'package:mediummerflutter/feature/task/commands/task_command.dart';
import 'package:mediummerflutter/feature/task/models/task.dart';
import 'package:mediummerflutter/feature/task/repositories/task_repository.dart';

/// Command for updating an existing task
class UpdateTaskCommand extends BaseTaskCommand {
  UpdateTaskCommand({
    required super.taskId,
    required Task newTask,
    required TaskRepository repository,
    super.timestamp,
  }) : _repository = repository,
       _newTask = newTask;
  final TaskRepository _repository;
  final Task _newTask;
  Task? _oldTask;

  @override
  Future<void> execute() async {
    _oldTask = await _repository.getTaskById(taskId);
    if (_oldTask != null) {
      await _repository.updateTask(_newTask);
    }
  }

  @override
  Future<void> undo() async {
    if (_oldTask != null) {
      await _repository.updateTask(_oldTask!);
    }
  }

  @override
  String get commandDescription => 'Update task: ${_newTask.title}';
}
