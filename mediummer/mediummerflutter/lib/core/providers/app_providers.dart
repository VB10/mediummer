import 'package:flutter/material.dart';
import 'package:mediummerflutter/feature/task/commands/task_command_manager.dart';
import 'package:mediummerflutter/feature/task/repositories/task_repository.dart';
import 'package:mediummerflutter/feature/task/viewmodels/task_view_model.dart';
import 'package:provider/provider.dart';

/// Widget that sets up all the providers for the application
class AppProviders extends StatelessWidget {
  const AppProviders({
    required this.child,
    super.key,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TaskRepository>(
          create: (_) => InMemoryTaskRepository(),
        ),
        Provider<TaskCommandManager>(
          create: (_) => TaskCommandManager(),
        ),
        ChangeNotifierProxyProvider2<TaskRepository, TaskCommandManager,
            TaskViewModel>(
          create: (context) => TaskViewModel(
            repository: context.read<TaskRepository>(),
            commandManager: context.read<TaskCommandManager>(),
          ),
          update: (context, repository, commandManager, previous) =>
              previous ??
              TaskViewModel(
                repository: repository,
                commandManager: commandManager,
              ),
        ),
      ],
      child: child,
    );
  }
}
