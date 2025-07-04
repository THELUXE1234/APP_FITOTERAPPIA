import 'package:app_fitoterappia/screens/menu_screen.dart';
import 'package:app_fitoterappia/ui/pages/crossword_match_page.dart';
import 'package:app_fitoterappia/ui/pages/startup_memory_page.dart';
import 'package:flutter/material.dart';

class JuegosMenuScreen extends StatelessWidget {
  const JuegosMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MenuScreen(), // Reemplaza con tu pantalla de inicio real
              ),
            );
          },
        ),
        title: Image.asset(
          'assets/logos/logo_menu.png',
          height: 90,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                
                // Título decorativo
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.brown, width: 2),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/juegos_icon.png', // Icono de juegos
                        height: 70,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Juegos",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3D813A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Botón para Memorice
                JuegoCard(
                  title: 'Memorice Plantas',
                  description: 'Pon a prueba tu memoria con este divertido juego de cartas.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StartUpPage()),
                    );
                  },
                ),

                const SizedBox(height: 20),

                //Botón para Sopa de Letras
                JuegoCard(
                  title: 'Sopa de Plantas',
                  description: 'Encuentra las palabras ocultas en la sopa de letras.',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CrosswordMatchPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// Widget para los botones de los juegos
class JuegoCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;

  const JuegoCard({
    required this.title,
    required this.description,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFFF6F6F6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D813A),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}