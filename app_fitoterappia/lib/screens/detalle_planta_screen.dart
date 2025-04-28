import 'package:app_fitoterappia/components/custom_app_bar_no_image.dart';
import 'package:app_fitoterappia/components/custom_navigation_bar.dart';
import 'package:app_fitoterappia/models/Plants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_fitoterappia/providers/plant_provider.dart';

class DetallePlantaScreen extends StatelessWidget {
  final Plants planta;
  const DetallePlantaScreen({super.key, required this.planta});

  void _showImagePreview(BuildContext context, String imagePath) {
    showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
      return Transform(
        transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
        child: Opacity(
          opacity: a1.value,
          child:  GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Cerrar la previsualización al tocar fuera
            },
            child: Center(
              child: Image.asset(
                imagePath, // Ruta de la imagen
                width: 350,
                height: 550,
                fit: BoxFit.contain, // Ajuste de la imagen para que no se distorsione
              ),
            ),
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 500),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {return Container();});
  }


  // Widget para crear una imagen secundaria
  Widget _buildSecondaryImage(BuildContext context, String imagePath) {
    return GestureDetector(
      onTap: () {
        _showImagePreview(context, imagePath); // Mostrar la previsualización al tocar
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12), // Imágenes redondeadas
        child: Image.asset(
          imagePath,
          width: 110, // Tamaño de la imagen secundaria (1/3 del tamaño de la principal)
          height: 110,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlantProvider>().planta = planta; // Guardamos la planta en el provider
    });
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9E3),
      appBar: CustomAppBarNoImageWithBackground(
        title: 'Precauciones y Contraindicaciones',
        backgroundImageAsset: 'assets/logos/detalles_wallpaper.png',
        firstIcon: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 140, // Barra de navegación fija
        child: buildNavigationBar(context),
      ),
      body: Column(
        children: [
          // Nombre común y científico
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 75, vertical: 0), //Espacio desde arriba y al lado
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFcfde52),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  planta.nombreComun ?? '',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 22, 48, 21),
                  ),
                ),
                Text(
                  planta.nombreCientifico ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 35),

          // Row para la imagen principal y las imágenes secundarias
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 37),
            child: Row(
              children: [
                // Imagen principal con previsualización
                Container(
                  margin: const EdgeInsets.only(right: 30),
                  child: GestureDetector(
                    onTap: () {
                      _showImagePreview(
                        context,
                        'assets/images/${planta.nombreComun?.toLowerCase()}.jpg',
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/${planta.nombreComun?.toLowerCase()}.jpg',
                        height: 350,
                        width: 197,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Imagenes secundarias
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSecondaryImage(context, 'assets/images/${planta.nombreComun?.toLowerCase()}_1.jpg'),
                    const SizedBox(height: 10),
                    _buildSecondaryImage(context, 'assets/images/${planta.nombreComun?.toLowerCase()}_2.jpg'),
                    const SizedBox(height: 10),
                    _buildSecondaryImage(context, 'assets/images/${planta.nombreComun?.toLowerCase()}_3.jpg'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
