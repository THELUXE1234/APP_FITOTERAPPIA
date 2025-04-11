import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_fitoterappia/providers/plant_provider.dart';

class AplicacionesUsoScreen extends StatefulWidget {
  const AplicacionesUsoScreen({super.key});

  @override
  _AplicacionesUsoScreenState createState() => _AplicacionesUsoScreenState();
}

class _AplicacionesUsoScreenState extends State<AplicacionesUsoScreen> {
  // Creamos un mapa para saber si el recuadro de cada botón está expandido
  late Map<String, bool> expandedSections;

  @override
  void initState() {
    super.initState();
    final planta = context.read<PlantProvider>().planta;
    expandedSections = {
      // Inicializamos las secciones con los nombres exactos de los botones.
      for (var efecto in planta?.efectos ?? [])
        efecto: false, // Inicializamos todos los efectos como no expandidos
    };
  }

  void _toggleSection(String section) {
    setState(() {
      expandedSections[section] = !expandedSections[section]!;
    });
  }

  // Función para obtener la infusión, manejando los casos de fuera de rango
  String _getInfusionInfo(int index, List<String>? infusiones) {
    // Verifica si el índice está dentro del rango de la lista de infusiones
    if (index < (infusiones?.length ?? 0)) {
      return infusiones?[index] ?? 'Información no disponible';
    }
    return 'Información no disponible'; // Si está fuera de rango, devuelve el mensaje predeterminado
  }
  // Función para obtener la descripción de los efectos de manera segura
  String _getEffectDescription(int index, List<String>? definicionEfectos) {
    if (index >= 0 && index < (definicionEfectos?.length ?? 0)) {
      return definicionEfectos?[index] ?? 'Descripción no disponible';
    }
    return 'Descripción no disponible'; // Si el índice está fuera de rango, devolver un valor predeterminado
  }

  // Widget para crear un botón terapéutico con título e información
  Widget _buildTherapeuticButton(
    String title,
    String iconPath,
    String description,
    String infusionInfo,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GestureDetector(
        onTap: () {
          _toggleSection(title); // Alternamos el estado de la expansión
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF59373e),
            borderRadius: BorderRadius.circular(90),
          ),
          child: Row(
            children: [
              // Icono
              Image.asset(
                iconPath,
                height: 40,
                width: 35,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 15),
              // Título y descripción
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Icono de información
              const Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 20,
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
          'Aplicaciones y uso Terapéutico',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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

            // Botones de uso terapéutico
            for (int i = 0; i < (planta?.efectos?.length ?? 0); i++)
              _buildTherapeuticButton(
                planta?.efectos?[i] ?? 'Efecto no disponible',
                'assets/icons/uso_icono_${(i % 4) + 1}.png',
                _getEffectDescription(i, planta?.definicionEfectos),
                _getInfusionInfo(i, planta?.infusiones),
                context,
              ),

            // Cuadro expandido para mostrar la infusión
            ...expandedSections.entries.map((entry) {
              final title = entry.key;
              final isExpanded = entry.value;
              final infusionesIndex = planta?.efectos?.indexOf(title);
              final infusionInfo =
                  _getInfusionInfo(infusionesIndex ?? 0, planta?.infusiones);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                height: isExpanded ? 120 : 0, // Controla la altura para expandir o colapsar
                child: isExpanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Infusión:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            infusionInfo,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      )
                    : const SizedBox(),
              );
            }).toList(),

            const SizedBox(height: 0.2),
            // Botones de acción en la parte inferior
            _buildNavigationBar(context),
          ],
        ),
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
