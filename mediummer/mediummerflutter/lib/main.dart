import 'package:flutter/material.dart';
import 'package:mediummerflutter/feature/plutoGrid/pluto_grid_home_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Material App', home: PlutoGridHomeView());
  }
}
