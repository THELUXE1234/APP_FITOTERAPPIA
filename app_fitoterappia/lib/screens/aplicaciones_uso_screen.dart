import 'package:app_fitoterappia/components/app_bar.dart';
import 'package:app_fitoterappia/components/custom_navigation_bar.dart';
import 'package:app_fitoterappia/models/Plants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_fitoterappia/providers/plant_provider.dart';

class AplicacionesUsoScreen extends StatefulWidget {
  const AplicacionesUsoScreen({super.key});

  @override
  _AplicacionesUsoScreenState createState() => _AplicacionesUsoScreenState();
}

class _AplicacionesUsoScreenState extends State<AplicacionesUsoScreen> {
  late Map<String, bool> expandedSections;
  int currentPage = 0;
  final int itemsPerPage = 4;

  @override
  void initState() {
    super.initState();
    final planta = context.read<PlantProvider>().planta;
    expandedSections = {
      for (var efecto in planta?.efectos ?? []) efecto: false,
    };
  }

  void _toggleSection(String section) {
    setState(() {
      expandedSections.updateAll((key, value) => key == section ? !value : false);
    });
  }

  String _getInfusionInfo(int index, List<String>? infusiones) {
    if (index < (infusiones?.length ?? 0)) {
      return infusiones?[index] ?? 'Información no disponible';
    }
    return 'Información no disponible';
  }

  String _getEffectDescription(int index, List<String>? definicionEfectos) {
    if (index >= 0 && index < (definicionEfectos?.length ?? 0)) {
      return definicionEfectos?[index] ?? 'Descripción no disponible';
    }
    return 'Descripción no disponible';
  }


 Widget _buildTherapeuticButton(String title, String iconPath,String description, String infusionInfo,  {required bool disabled,}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: AbsorbPointer(
        // Impide interacciones si está desactivado
        absorbing: disabled,
        child: Opacity(
          // Semitransparencia para indicar estado deshabilitado
          opacity: disabled ? 0.1 : 1.0,
          child: GestureDetector(
            onTap: () => _toggleSection(title),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF59373e),
                borderRadius: BorderRadius.circular(90),
              ),
              child: Row(
                children: [
                  Image.asset(iconPath, height: 40, width: 35, fit: BoxFit.cover),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 0),
                        Text(
                          description,
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.info_outline, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildEffectOverlay(String effect,  int index, Plants planta) {
    return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Container(
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
                'Infusión:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                _getInfusionInfo(index, planta?.infusiones),
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final planta = context.watch<PlantProvider>().planta;
    final _iconSize = 65.0;
    final totalItems = planta?.efectos?.length ?? 0;
    final totalPages = (totalItems / itemsPerPage).ceil();

    final startIndex = currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage) > totalItems
        ? totalItems
        : startIndex + itemsPerPage;

    final currentItems = (planta?.efectos ?? []).sublist(startIndex, endIndex);
    final hasAnyExpanded = expandedSections.values.any((isExp) => isExp);   
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Aplicaciones y uso Terapeútico',
        childHeight: _iconSize + 30,
        color: const Color(0xFFeab463),
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
                    'assets/icons/icon_precauciones_seccion.png',
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
        height: 140,
        child: buildNavigationBar(context),
      ),
      body: Column(
        children: [
          // 🌿 Nombre de la planta
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 75, vertical: 0),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E652),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              planta?.nombreComun ?? 'Planta no encontrada',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF59373e),
              ),
            ),
          ),
          const SizedBox(height: 5),
          // 🌿 Contenedor de los botones y las flechas laterales
          Expanded(
            child: Stack(
              children: [
                // Contenedor principal con flechas y botones
                Row(
                  children: [
                    // Flecha izquierda
                    SizedBox(
                      width: 40,
                      height: 100,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_left, size: 40),
                        onPressed: currentPage > 0
                            ? () => setState(() => currentPage--)
                            : null,
                      ),
                    ),
                    // Botones terapéuticos (visibles todo el tiempo)
                    Expanded(
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: currentItems.map<Widget>((efecto) {
                          final index = (planta?.efectos ?? []).indexOf(efecto);
                          final isExpanded = expandedSections[efecto] ?? false;

                          String buttonType;
                          switch (index % 4) {
                            case 0:
                              buttonType = "Typebutton1";
                              break;
                            case 1:
                              buttonType = "Typebutton2";
                              break;
                            case 2:
                              buttonType = "Typebutton3";
                              break;
                            default:
                              buttonType = "Typebutton4";
                          }

                          return _buildTherapeuticButton(
                            efecto,
                            'assets/icons/uso_icono_${(index % 4) + 1}.png',
                            _getEffectDescription(index, planta?.definicionEfectos),
                            _getInfusionInfo(index, planta?.infusiones),
                            disabled: hasAnyExpanded && !isExpanded,
                            
                          );
                        }).toList(),
                      ),
                    ),
                    // Flecha derecha
                    SizedBox(
                      width: 35,
                      height: 100,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_right, size: 40),
                        onPressed: currentPage < totalPages - 1
                            ? () => setState(() => currentPage++)
                            : null,
                      ),
                    ),
                  ],
                ),

                // Overlay flotante (solo uno visible a la vez)
                if (hasAnyExpanded)
                  Positioned(
                    child: Container(
                      //color: Colors.black.withOpacity(0.3), // Fondo semitransparente                      
                        child: SingleChildScrollView(
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: currentItems.map<Widget>((efecto) {
                              final index = (planta?.efectos ?? []).indexOf(efecto);
                              final isExpanded = expandedSections[efecto] ?? false;
                              if (!isExpanded) return const SizedBox.shrink();

                              String buttonType = "Typebutton${(index % 4) + 1}";

                              // Posición personalizada por tipo de botón
                              Alignment alignment;
                              EdgeInsets padding;
                              
                              late double maxHeight;
                              maxHeight = MediaQuery.of(context).size.height
                                    - kToolbarHeight  // AppBar
                                    - 140             // Altura del BottomNavigationBar
                                    - 150;            // Estimación de espacio ocupado por otros widgets
                              switch (buttonType) {
                                case "Typebutton1": // Centro inferior
                                  alignment = Alignment.topCenter;
                                  padding = const EdgeInsets.only(top: 70);
                                  break;
                                case "Typebutton2": // Centro superior
                                  alignment = Alignment.topCenter;
                                  padding = const EdgeInsets.only(top: 160);
                                  break;
                                case "Typebutton3": // Izquierda media
                                  alignment = Alignment.topCenter;
                                  padding = const EdgeInsets.only(top: 80);
                                  break;
                                case "Typebutton4": // Derecha media
                                  alignment = Alignment.topCenter;
                                  padding = const EdgeInsets.only(top:150);
                                  break;
                                default:
                                  alignment = Alignment.center;
                                  padding = EdgeInsets.zero;
                              }

                              return Align(
                                alignment: alignment,
                                child: Padding(
                                  padding: padding,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => _toggleSection(efecto),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(maxHeight: maxHeight),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _buildEffectOverlay(efecto, index, planta),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );

                            }).toList()
                          ),
                        ),
                      
                    ),
                  ),
              ],
            ),
          ),

        ],
      ),

    );
  }
}
