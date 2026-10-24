import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';

void main() {
  runApp(const SokobanApp());
}

class SokobanApp extends StatelessWidget {
  const SokobanApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sokoban Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const LoadingScreen(),
    );
  }
}
