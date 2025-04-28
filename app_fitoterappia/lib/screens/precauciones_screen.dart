import 'package:app_fitoterappia/components/app_bar.dart';
import 'package:app_fitoterappia/components/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_fitoterappia/providers/plant_provider.dart';

class PrecaucionesScreen extends StatefulWidget {
  const PrecaucionesScreen({super.key});

  @override
  _PrecaucionesScreenState createState() => _PrecaucionesScreenState();
}

class _PrecaucionesScreenState extends State<PrecaucionesScreen> {
  // Creamos un mapa para saber si el recuadro de cada botón está expandido
  late Map<String, bool> expandedSections;

  @override
  void initState() {
    super.initState();
    expandedSections = {
      'PRECAUCIONES GENERALES': false,
      'CONTRAINDICACIONES': false,
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
        // Impide interacciones si está desactivado
        absorbing: disabled,
        child: Opacity(
          // Semitransparencia para indicar estado deshabilitado
          opacity: disabled ? 0.5 : 1.0,
          child: GestureDetector(
            onTap: () => _toggleSection(title),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
        title: 'Precauciones y Contraindicaciones',
        childHeight: _iconSize + 30,
        color: Color(0xFFb24e97),
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
                    'assets/icons/icon_precauciones_seccion.png',
                    height: _iconSize,
                    width: _iconSize,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Text(
                'Precauciones y Contraindicaciones',
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
        height: 140, // <-- Ajusta a la altura real que quieras que tenga tu barra
        child: buildNavigationBar(context),
      ),
      body: Column(
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
          const SizedBox(height: 10),

          // ---------- Botón Precauciones Generales ----------
          _buildInfoSection(
            'PRECAUCIONES GENERALES',
            disabled: hasAnyExpanded &&
                !expandedSections['PRECAUCIONES GENERALES']!,
          ),

          // ---------- Overlay Precauciones Generales ----------
          if (expandedSections['PRECAUCIONES GENERALES']!)
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
                        'Precauciones Generales:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        planta?.precauciones ??
                            'Información no disponible',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            // ---------- Botón Contraindicaciones (solo si no está abierto Precauciones) ----------
            _buildInfoSection(
              'CONTRAINDICACIONES',
              disabled: hasAnyExpanded &&
                  !expandedSections['CONTRAINDICACIONES']!,
            ),

            // ---------- Overlay Contraindicaciones ----------
            if (expandedSections['CONTRAINDICACIONES']!)
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 5),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Colors.black, width: 2),
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
                          'Contraindicaciones:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          planta?.otrosAntecedentes ?? 'Información no disponible',
                          style: const TextStyle(fontSize: 14),
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
