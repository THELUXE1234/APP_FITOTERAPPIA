import 'package:app_fitoterappia/screens/buscar_efecto_screen.dart';
import 'package:app_fitoterappia/screens/buscar_nombre_screen.dart';
import 'package:app_fitoterappia/screens/glosario_screen.dart';
import 'package:app_fitoterappia/screens/videoteca_screen.dart';
import 'package:flutter/material.dart';


class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Funciones que redirigen
    final List<Map<String, dynamic>> menuItems = [
      {
        "title": "Buscar por\nNombre",
        "image": "assets/icons/buscar_nombre_icon.png",
        "funcion": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BuscarNombreScreen()),
          );
        }
      },
      {
        "title": "Buscar por\nEfecto",
        "image": "assets/icons/buscar_efecto_icon.png",
        "funcion": () {
          // Aquí puedes redirigir a otra pantalla
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BuscarEfectoScreen()),
          );
        }
      },
      {
        "title": "Videoteca",
        "image": "assets/icons/videoteca_icon.png",
        "funcion": () {
          // Aquí puedes redirigir a otra pantalla
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VideotecaScreen()),
          );
        }
      },
      {
        "title": "Glosario",
        "image": "assets/icons/glosario_icon.png",
        "funcion": () {
          // Aquí puedes redirigir a otra pantalla
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GlosarioScreen()),
          );
        }
      },
      {
        "title": "Juegos",
        "image": "assets/icons/juegos_icon.png",
        "funcion": () {
          // Aquí puedes redirigir a otra pantalla
        }
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Image.asset(
          'assets/logos/logo_menu.png',
          height: 90,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return _buildMenuItem(
                    menuItems[index]["title"]!,
                    menuItems[index]["image"]!,
                    () => menuItems[index]["funcion"](),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                height: 60,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 2),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
