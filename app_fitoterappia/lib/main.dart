import 'package:app_fitoterappia/core/app_colors.dart';
import 'package:app_fitoterappia/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.background,
        body: HomeScreen(),
      ),
    );
  }
}
