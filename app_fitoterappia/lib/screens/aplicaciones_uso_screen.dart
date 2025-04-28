import 'package:app_fitoterappia/components/app_bar.dart';
import 'package:app_fitoterappia/components/custom_navigation_bar.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GestureDetector(
        onTap: () {
          _toggleSection(title); // Alternamos el estado de la expansión
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 3),
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
                      title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 13,
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
    final _iconSize = 65.0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Aplicaciones y uso Terapeútico',
        childHeight: _iconSize + 30,
        color: Color(0xFFeab463),
        firstIcon: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        child: Transform.translate(
          offset: const Offset(0, -35), // Eleva la imagen hacia arriba
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 5.0, color: Colors.white),
                ),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/icons/icon_aplicaciones_seccion.png',
                    height: _iconSize,
                    width: _iconSize,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Text(
                'Aplicaciones y uso Terapeútico',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 140, // Ajustado para que no se expanda
        child: buildNavigationBar(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Título de la planta
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 75, vertical: 0),
              padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 5),
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF59373e),
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
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                height: isExpanded ? 250 : 0, // Controla la altura para expandir o colapsar
                child: isExpanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Infusión:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
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
          ],
        ),
      ),
    );
  }


}
