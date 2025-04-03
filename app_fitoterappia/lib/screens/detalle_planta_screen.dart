import 'package:app_fitoterappia/models/Plants.dart';
import 'package:flutter/material.dart';

class DetallePlantaScreen extends StatelessWidget {
  final Plants planta;
  const DetallePlantaScreen({super.key, required this.planta});

  // Función para mostrar la previsualización de la imagen
  void _showImagePreview(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierDismissible: true, // Permite cerrar tocando fuera de la imagen
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Fondo transparente
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Cerrar la previsualización al tocar fuera
            },
            child: Center(
              child: Image.asset(
                imagePath, // Ruta de la imagen
                fit: BoxFit.contain, // Ajuste de la imagen para que no se distorsione
              ),
            ),
          ),
        );
      },
    );
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

  // Widget para los botones circulares con título debajo
  Widget _buildActionButton(String title, String iconPath, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30, // Hace el botón circular
            backgroundColor: color, // Fondo verde
            child: ClipOval(
              child: Image.asset(
                iconPath,
                height: 50,
                width: 50,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9E3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Nombre común y científico
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 75, vertical: 2), //Espacio desde arriba y al lado
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E652),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  planta.nombreComun ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D813A),
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
          const SizedBox(height: 20),

          // Row para la imagen principal y las imágenes secundarias
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 37),
            child: Row(
              children: [
                // Imagen principal
                Container(
                  margin: const EdgeInsets.only(right: 30), // Mayor espacio entre la imagen principal y las secundarias
                  child: Image.asset(
                    'assets/images/ajenjo.jpg', // Asegúrate de tener la imagen en assets
                    height: 350, // Tamaño de la imagen principal
                    fit: BoxFit.cover, // Ajusta la imagen para que no se distorsione
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

          // Botones de acción en la parte inferior con iconos circulares y títulos debajo
          const SizedBox(height: 58),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 25),
            decoration: const BoxDecoration(
              color: Color(0xFF294029),
              borderRadius: BorderRadius.vertical(top: Radius.circular(90)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  'Aplicaciones', 
                  'assets/icons/aplicaciones_icon.png', 
                  () {
                    // Aquí puedes redirigir a la vista de Aplicaciones
                    print("Navegando a Aplicaciones");
                  },
                  Color(0xFFeab463)
                ),
                _buildActionButton(
                  'Cultivo', 
                  'assets/icons/cultivo_icon.png', 
                  () {
                    // Aquí puedes redirigir a la vista de Cultivo
                    print("Navegando a Cultivo");
                  }, 
                  Color(0xFFc2c2c4)
                ),
                _buildActionButton(
                  'Precauciones', 
                  'assets/icons/precauciones_icon.png', 
                  () {
                    // Aquí puedes redirigir a la vista de Precauciones
                    print("Navegando a Precauciones");
                  },
                  Color(0xFFb24e97)
                ),
                _buildActionButton(
                  'Recursos', 
                  'assets/icons/recursos_icon.png', 
                  () {
                    // Aquí puedes redirigir a la vista de Recursos
                    print("Navegando a Recursos");
                  },
                  Color(0xFF57a4a7)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
