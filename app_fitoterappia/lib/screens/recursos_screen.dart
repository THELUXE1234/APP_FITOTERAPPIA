import 'package:app_fitoterappia/components/app_bar.dart';
import 'package:app_fitoterappia/components/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_fitoterappia/providers/plant_provider.dart';

class InfoFarmacologicaScreen extends StatefulWidget {
  const InfoFarmacologicaScreen({super.key});

  @override
  _InfoFarmacologicaScreenState createState() => _InfoFarmacologicaScreenState();
}

class _InfoFarmacologicaScreenState extends State<InfoFarmacologicaScreen> {
  late Map<String, bool> expandedSections;

  @override
  void initState() {
    super.initState();
    expandedSections = {
      'INFORMACIÓN FARMACOLÓGICA': false,
      'REFERENCIAS': false,
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
        title: 'Información Avanzada (Recursos)',
        childHeight: _iconSize + 30,
        color: const Color(0xFF57a4a7),
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
                    'assets/icons/icon_recursos_seccion.png',
                    height: _iconSize,
                    width: _iconSize,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Text(
                'Información Avanzada (Recursos)',
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

          // Botón de Información Farmacológica
          _buildInfoSection(
            'INFORMACIÓN FARMACOLÓGICA',
            disabled: hasAnyExpanded && !expandedSections['INFORMACIÓN FARMACOLÓGICA']!,
          ),

          // Overlay Información Farmacológica
          if (expandedSections['INFORMACIÓN FARMACOLÓGICA']!)
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
                        'Información Farmacológica:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                       if (planta?.usosTradicionales != null && planta!.usosTradicionales!.isNotEmpty)
                        const Text(
                          'Usos Tradicionales:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (planta?.usosTradicionales != null && planta!.usosTradicionales!.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: planta?.usosTradicionales?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Text(
                              '${index + 1}. ${planta!.usosTradicionales![index]}',
                              style: const TextStyle(fontSize: 14),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            )
          else ...[
            // Botón de Referencias
            _buildInfoSection(
              'REFERENCIAS',
              disabled: hasAnyExpanded && !expandedSections['REFERENCIAS']!,
            ),

            // Overlay Referencias
            if (expandedSections['REFERENCIAS']!)
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
                          'Referencias:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Información no disponible',
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
