import 'package:flutter/material.dart';
import 'package:mediummerflutter/feature/memory_management/memory_management.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MemoryManagementExamples(),
      // home: const PlutoGridHomeView(),
    );
  }
}
