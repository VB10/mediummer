import 'package:flutter/material.dart';
import 'package:mediummerflutter/feature/messaging/views/messaging_home_page.dart';

void main() {
  runApp(const MessagingApp());
}

class MessagingApp extends StatelessWidget {
  const MessagingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mediator Messaging App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MessagingHomePage(),
    );
  }
}
