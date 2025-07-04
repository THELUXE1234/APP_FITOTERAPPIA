import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_fitoterappia/models/Plants.dart';
import 'package:app_fitoterappia/screens/detalle_planta_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class BuscarEfectoScreen extends StatefulWidget {
  const BuscarEfectoScreen({super.key});

  @override
  State<BuscarEfectoScreen> createState() => _BuscarEfectoScreenState();
}

class _BuscarEfectoScreenState extends State<BuscarEfectoScreen> {
  List<Plants> plantas = [];
  List<Plants> plantasFiltradas = [];
  Set<String> efectosDisponibles = {};
  String busqueda = "";
  int? selectedIndex;

  final TextEditingController _searchController = TextEditingController();

  bool showInitialMessage = true; // PARA MOSTRAR EL MENSAJE AL ENTRAR

  String normalizeString(String text) {
    text = text.toLowerCase();
    text = text.replaceAll('á', 'a');
    text = text.replaceAll('é', 'e');
    text = text.replaceAll('í', 'i');
    text = text.replaceAll('ó', 'o');
    text = text.replaceAll('ú', 'u');
    text = text.replaceAll('-', ' ');
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    return text.trim();
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  Future<void> checkSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastSyncDate');
    final lastSyncDate = prefs.getString('lastSyncDate');
    final currentDate = DateTime.now().toString().split(' ')[0];

    if (lastSyncDate == null || lastSyncDate != currentDate) {
      await syncData();
    }
    await loadLocalData();
  }

  Future<void> syncData() async {
    final apiUrl = dotenv.env['API_URL'];
    final uri = Uri.parse('$apiUrl/plantas');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        await saveDataLocally(response.body);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('lastSyncDate', DateTime.now().toString().split(' ')[0]);
      } else {
        throw Exception("Fallo la conexión");
      }
    } catch (e) {
      print("Error de sincronización: $e");
    }
  }

  Future<void> saveDataLocally(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/plantas.json');
    await file.writeAsString(data);
  }

  Future<void> loadLocalData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/plantas.json');

    if (await file.exists()) {
      final data = await file.readAsString();
      setState(() {
        plantas = (json.decode(data) as List).map((json) => Plants.fromJson(json)).toList();
        efectosDisponibles.clear();
        for (var planta in plantas) {
          if (planta.efectos != null) {
            for (var efecto in planta.efectos!) {
              efectosDisponibles.add(normalizeString(efecto));
            }
          }
        }
      });
      print("data cargada y efectos recolectados");
    } else {
      showErrorMessage();
    }
  }

  void showErrorMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sin Conexión a Internet"),
        content: const Text("Por favor, conecta a internet para sincronizar los datos."),
        actions: <Widget>[
          TextButton(
            child: const Text("Aceptar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showEfectosList() {
    List<String> sortedEfectos = efectosDisponibles.toList()..sort();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Selecciona un efecto"),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 1,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: sortedEfectos.length,
            itemBuilder: (context, index) {
              final efecto = sortedEfectos[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  setState(() {
                    busqueda = efecto;
                    _searchController.text = efecto;
                    showInitialMessage = false;
                  });
                  filtrarPlantas(efecto);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFAED189),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    capitalize(efecto),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: const Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkSync();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filtrarPlantas(String query) {
    setState(() {
      busqueda = query;
      selectedIndex = null;
      if (query.isEmpty) {
        plantasFiltradas = [];
        showInitialMessage = true;
      } else {
        final normalizedQuery = normalizeString(query);
        plantasFiltradas = plantas.where((planta) {
          return planta.efectos != null &&
              planta.efectos!.any((efecto) => normalizeString(efecto).contains(normalizedQuery));
        }).toList();
        plantasFiltradas.sort((a, b) => a.nombreComun!.compareTo(b.nombreComun!));
        showInitialMessage = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.brown, width: 2),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/buscar_efecto_icon.png',
                        height: 70,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Buscar por\nEfecto",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3D813A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // --- Mensaje inicial ---
                if (showInitialMessage)
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F0D9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF3D813A)),
                    ),
                    child: const Text(
                      "Para mayor rapidez, abre el botón y selecciona un efecto.",
                      style: TextStyle(color: Color(0xFF3D813A), fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFAED189),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: filtrarPlantas,
                        style: const TextStyle(fontSize: 17),
                        decoration: const InputDecoration(
                          hintText: "Ingresa un efecto",
                          border: InputBorder.none,
                          suffixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.only(left: 20, top: 9, bottom: 10),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline, size: 30),
                      color: const Color(0xFF3D813A),
                      onPressed: _showEfectosList,
                    ),
                  ],
                ),

                const SizedBox(height: 1),

                if (busqueda.isNotEmpty)
                  plantasFiltradas.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text("No se encontraron plantas con ese efecto"),
                        )
                      : Container(
                          width: 300,
                          constraints: const BoxConstraints(maxHeight: 200),
                          margin: const EdgeInsets.only(top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: plantasFiltradas.length,
                            itemBuilder: (context, i) {
                              final planta = plantasFiltradas[i];
                              final esSeleccionado = selectedIndex == i;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = i;
                                  });
                                  Future.delayed(const Duration(milliseconds: 200), () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetallePlantaScreen(planta: planta),
                                      ),
                                    );
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: esSeleccionado
                                        ? const Color(0xFF3D813A)
                                        : const Color(0xFFF6F6F6),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    "${planta.nombreComun} ${planta.nombreCientifico ?? ''}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: esSeleccionado ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
