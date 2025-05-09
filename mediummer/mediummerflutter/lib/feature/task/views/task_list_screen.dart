import 'package:flutter/material.dart';
import 'package:mediummerflutter/core/constants/app_strings.dart';
import 'package:mediummerflutter/core/providers/app_providers.dart';
import 'package:mediummerflutter/feature/task/mixins/task_list_operations.dart';
import 'package:mediummerflutter/feature/task/models/task.dart';
import 'package:mediummerflutter/feature/task/viewmodels/task_view_model.dart';
import 'package:provider/provider.dart';

class TaskListProvider extends StatelessWidget {
  const TaskListProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppProviders(
      child: TaskListScreen(),
    );
  }
}

/// Main screen for displaying and managing tasks
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with TaskListOperations {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        actions: [
          Consumer<TaskViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                icon: const Icon(Icons.undo),
                onPressed: viewModel.canUndo ? () => handleUndo(context) : null,
              );
            },
          ),
          Consumer<TaskViewModel>(
            builder: (context, viewModel, child) {
              return IconButton(
                icon: const Icon(Icons.redo),
                onPressed: viewModel.canRedo ? () => handleRedo(context) : null,
              );
            },
          ),
        ],
      ),
      body: Consumer<TaskViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.tasks.isEmpty) {
            return const Center(
              child: Text(AppStrings.noTasksMessage),
            );
          }

          return ListView.builder(
            itemCount: viewModel.tasks.length,
            itemBuilder: (context, index) {
              final task = viewModel.tasks[index];
              return TaskListTile(
                task: task,
                onToggleComplete: (isCompleted) =>
                    handleTaskCompletion(context, task, isCompleted),
                onDelete: () => handleTaskDeletion(context, task.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Widget for displaying a single task in the list
class TaskListTile extends StatelessWidget {
  const TaskListTile({
    required this.task,
    required this.onToggleComplete,
    required this.onDelete,
    super.key,
  });

  final Task task;
  final ValueChanged<bool> onToggleComplete;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (value) => onToggleComplete(value ?? false),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(task.description),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
