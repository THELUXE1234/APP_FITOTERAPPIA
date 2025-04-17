import 'package:app_fitoterappia/screens/aplicaciones_uso_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_fitoterappia/providers/plant_provider.dart';

class CultivoRecoleccionScreen extends StatefulWidget {
  const CultivoRecoleccionScreen({super.key});

  @override
  _CultivoRecoleccionScreenState createState() =>
      _CultivoRecoleccionScreenState();
}

class _CultivoRecoleccionScreenState extends State<CultivoRecoleccionScreen> {
  // Creamos un mapa para saber si el recuadro de cada botón está expandido
  late Map<String, bool> expandedSections;

  @override
  void initState() {
    super.initState();
    expandedSections = {
      'DESCRIPCIÓN DE LA PLANTA': false,
      'CULTIVO Y RECOLECCIÓN': false,
    };
  }

  void _toggleSection(String section) {
    setState(() {
      expandedSections.updateAll((key, value) => key == section ? !value : false);
    });
  }

  // Función para mostrar los cuadros de información
  Widget _buildInfoSection(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: GestureDetector(
        onTap: () {
          _toggleSection(title); // Alternamos el estado de la expansión
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF59373e),
            borderRadius: BorderRadius.circular(90),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final planta = context.watch<PlantProvider>().planta;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9E3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recomendaciones para el \n                 Cultivo',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Título de la planta
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 75, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E652),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  planta?.nombreComun ?? 'Planta no encontrada',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D813A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // Botón de "Descripción de la Planta"
          _buildInfoSection('DESCRIPCIÓN DE LA PLANTA'),

          // Botón de "Cultivo y Recolección"
          _buildInfoSection('CULTIVO Y RECOLECCIÓN'),

          // Cuadro expandido para mostrar la información
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: expandedSections.entries.map((entry) {
                  final title = entry.key;
                  final isExpanded = entry.value;

                  return AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: isExpanded
                        ? Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black, width: 2), // Borde negro de 2px
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (title == 'CULTIVO Y RECOLECCIÓN') ...[
                                  const Text(
                                    'Instrucciones cultivo:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    planta?.instruccionesDeCultivo ?? 'Información no disponible',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Cuidado y cosecha:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    planta?.cuidadoYCosecha ?? 'Información no disponible',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ] else ...[
                                  Text(
                                    planta?.descripcion ?? 'Información no disponible',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  );
                }).toList(),
              ),
            ),
          ),

          //const SizedBox(height: 250),
          // Botones de acción en la parte inferior
          const SizedBox(height: 5),
          _buildNavigationBar(context),
        ],
      ),
    );
  }

  // Widget para la barra de navegación en la parte inferior
  Widget _buildNavigationBar(BuildContext context) {
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
            'Aplicaciones',
            'assets/icons/aplicaciones_icon.png',
            () {
              print("Navegando a Aplicaciones");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AplicacionesUsoScreen()),
              );
            },
            const Color(0xFFeab463),
          ),
          _buildActionButton(
            'Cultivo',
            'assets/icons/cultivo_icon.png',
            () {
              print("Navegando a Cultivo");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CultivoRecoleccionScreen()),
              );
            },
            const Color(0xFFc2c2c4),
          ),
          _buildActionButton(
            'Precauciones',
            'assets/icons/precauciones_icon.png',
            () {
              print("Navegando a Precauciones");
            },
            const Color(0xFFb24e97),
          ),
          _buildActionButton(
            'Recursos',
            'assets/icons/recursos_icon.png',
            () {
              print("Navegando a Recursos");
            },
            const Color(0xFF57a4a7),
          ),
        ],
      ),
    );
  }

  // Widget para los botones de navegación inferiores
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
}

// Custom ClipPath para redondear el AppBar
class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 20); // Borde inferior del AppBar
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 20); // Curvatura
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}