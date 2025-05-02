import 'package:app_fitoterappia/components/app_bar.dart';
import 'package:app_fitoterappia/components/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_fitoterappia/providers/plant_provider.dart';

class CultivoRecoleccionScreen extends StatefulWidget {
  const CultivoRecoleccionScreen({super.key});

  @override
  _CultivoRecoleccionScreenState createState() => _CultivoRecoleccionScreenState();
}

class _CultivoRecoleccionScreenState extends State<CultivoRecoleccionScreen> {
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

  /// Construye un botón que puede desactivarse y volverse semitransparente
  Widget _buildInfoSection(String title, {required bool disabled}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: AbsorbPointer(
        absorbing: disabled,
        child: Opacity(
          opacity: disabled ? 0.5 : 1.0,
          child: GestureDetector(
            onTap: () => _toggleSection(title),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF59373e),
                borderRadius: BorderRadius.circular(90),
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final planta = context.watch<PlantProvider>().planta;
    final hasAnyExpanded = expandedSections.values.any((isExp) => isExp);
    final _iconSize = 65.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Recomendaciones para el cultivo',
        childHeight: _iconSize + 30,
        color: const Color(0xFFc2c2c4),
        firstIcon: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        child: Transform.translate(
          offset: const Offset(0, -35),
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
                    'assets/icons/icon_recomendaciones_seccion.png',
                    height: _iconSize,
                    width: _iconSize,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Text(
                'Recomendaciones para el cultivo',
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
        height: 140, // Barra de navegación fija
        child: buildNavigationBar(context),
      ),
      body: Column(
        children: [
          // Título de la planta
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 75, vertical: 0),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
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
          const SizedBox(height: 10),

          // Botón de Descripción de la Planta
          _buildInfoSection(
            'DESCRIPCIÓN DE LA PLANTA',
            disabled: hasAnyExpanded && !expandedSections['DESCRIPCIÓN DE LA PLANTA']!,
          ),

          if (expandedSections['DESCRIPCIÓN DE LA PLANTA']!)
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  padding: const EdgeInsets.all(15),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descripción:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        planta?.descripcion ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text(
                            'Tipo de planta: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            planta?.tipoDePlanta ?? "Información no disponible",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Altura: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            planta?.altura ?? "Información no disponible",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Hojas: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            planta?.hojas ?? "Información no disponible",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Flores: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            planta?.flores ?? "Información no disponible",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Periodo de vida: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            planta?.periodoDeVida ?? "Información no disponible",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      
                    ],
                  ),
                ),
              ),
            )
          else ...[
            // Botón de Cultivo y Recolección
            _buildInfoSection(
              'CULTIVO Y RECOLECCIÓN',
              disabled: hasAnyExpanded && !expandedSections['CULTIVO Y RECOLECCIÓN']!,
            ),

            if (expandedSections['CULTIVO Y RECOLECCIÓN']!)
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    padding: const EdgeInsets.all(15),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Instrucciones de Cultivo:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          planta?.instruccionesDeCultivo ?? 'Información no disponible',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Cuidado y Cosecha:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          planta?.cuidadoYCosecha ?? 'Información no disponible',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),          // Usamos Row para mostrar el nombre y el valor en la misma línea
                        Text(
                          'Temperatura ideal: ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          planta?.temperaturaIdeal ?? "Información no disponible",
                          style: const TextStyle(fontSize: 14),
                        ),
                          Row(
                            children: [
                              const Text(
                                'Exposición solar: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                planta?.exposicionSolar ?? "Información no disponible",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Suelo: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                planta?.suelo ?? "Información no disponible",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Propagación: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                planta?.propagacion ?? "Información no disponible",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Riego: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                planta?.riego ?? "Información no disponible",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Cosecha: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                planta?.cosecha ?? "Información no disponible",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
          ],

          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
