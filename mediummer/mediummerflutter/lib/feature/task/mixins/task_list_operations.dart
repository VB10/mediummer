import 'package:flutter/material.dart';
import 'package:mediummerflutter/feature/task/models/task.dart';
import 'package:mediummerflutter/feature/task/viewmodels/task_view_model.dart';
import 'package:mediummerflutter/feature/task/views/add_task_dialog.dart';
import 'package:mediummerflutter/feature/task/views/task_list_screen.dart';
import 'package:provider/provider.dart';

/// Mixin that provides task list operations
mixin TaskListOperations on State<TaskListScreen> {
  late final TaskViewModel taskViewModel = context.read<TaskViewModel>();

  /// Shows the add task dialog
  Future<void> showAddTaskDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onTaskAdded: (task) {
          taskViewModel.createTask(task.key, task.value);
        },
      ),
    );
  }

  /// Handles task completion toggle
  void handleTaskCompletion(BuildContext context, Task task, bool isCompleted) {
    taskViewModel.updateTask(
      task.copyWith(
        isCompleted: isCompleted,
        completedAt: isCompleted ? DateTime.now() : null,
      ),
    );
  }

  /// Handles task deletion
  void handleTaskDeletion(BuildContext context, String taskId) {
    context.read<TaskViewModel>().deleteTask(taskId);
  }

  /// Handles undo operation
  void handleUndo(BuildContext context) {
    context.read<TaskViewModel>().undo();
  }

  /// Handles redo operation
  void handleRedo(BuildContext context) {
    context.read<TaskViewModel>().redo();
  }
}
