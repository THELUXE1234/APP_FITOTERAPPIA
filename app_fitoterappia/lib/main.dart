import 'package:app_fitoterappia/core/app_colors.dart';
import 'package:app_fitoterappia/providers/plant_provider.dart';
import 'package:app_fitoterappia/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Cargar las variables de entorno antes de ejecutar la aplicación
  await dotenv.load(); 

  runApp(
    ChangeNotifierProvider(
      create: (context) => PlantProvider(),
      child: const MainApp(),
    ),
  );
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
