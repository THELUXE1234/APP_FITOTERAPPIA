// custom_navigation_bar.dart
import 'package:app_fitoterappia/screens/precauciones_screen.dart';
import 'package:app_fitoterappia/screens/recursos_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_fitoterappia/screens/aplicaciones_uso_screen.dart';
import 'package:app_fitoterappia/screens/cultivo_recoleccion_screen.dart';

Widget buildNavigationBar(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 25),
    decoration: const BoxDecoration(
      color: Color(0xFF294029),
      borderRadius: BorderRadius.vertical(top: Radius.circular(90)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          context,
          'Aplicaciones',
          'assets/icons/aplicaciones_icon.png',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AplicacionesUsoScreen()),
            );
          },
          const Color(0xFFeab463),
        ),
        _buildActionButton(
          context,
          'Cultivo',
          'assets/icons/cultivo_icon.png',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CultivoRecoleccionScreen()),
            );
          },
          const Color(0xFFc2c2c4),
        ),
        _buildActionButton(
          context,
          'Precauciones',
          'assets/icons/precauciones_icon.png',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrecaucionesScreen()),
            );
          },
          const Color(0xFFb24e97),
        ),
        _buildActionButton(
          context,
          'Recursos',
          'assets/icons/recursos_icon.png',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const InfoFarmacologicaScreen()),
            );
          },
          const Color(0xFF57a4a7),
        ),
      ],
    ),
  );
}

Widget _buildActionButton(
  BuildContext context,
  String title,
  String iconPath,
  VoidCallback onTap,
  Color color,
) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: ClipOval(
            child: Image.asset(
              iconPath,
              height: 60,
              width: 60,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
