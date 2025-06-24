import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_fitoterappia/models/Plants.dart';
import 'package:app_fitoterappia/screens/detalle_planta_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class BuscarNombreScreen extends StatefulWidget {
  const BuscarNombreScreen({super.key});

  @override
  State<BuscarNombreScreen> createState() => _BuscarNombreScreenState();
}

class _BuscarNombreScreenState extends State<BuscarNombreScreen> {
  List<Plants> plantas = [];
  List<Plants> plantasFiltradas = [];
  String busqueda = "";
  int? selectedIndex;
  final TextEditingController _searchController = TextEditingController();
  // Nueva variable de estado para controlar la visibilidad de la lista
  bool _mostrarLista = false;

  // Verificar si se debe hacer la sincronización (una vez por semana)
  Future<void> checkSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastSyncDate');
    final lastSyncDate = prefs.getString('lastSyncDate');
    final currentDate = DateTime.now().toString().split(' ')[0]; // Solo fecha (YYYY-MM-DD)

    if (lastSyncDate == null || lastSyncDate != currentDate) {
      await syncData(); // Si es la primera vez o ha pasado más de una semana, sincronizamos
    }
    await loadLocalData();
  }

  // Sincronizar datos desde la API
  Future<void> syncData() async {
    final apiUrl = dotenv.env['API_URL'];
    final uri = Uri.parse('$apiUrl/plantas');


    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Guardamos los datos localmente
        await saveDataLocally(response.body);
        print("listo");
        // Actualizamos la fecha de la última sincronización
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('lastSyncDate', DateTime.now().toString().split(' ')[0]);
      } else {
        throw Exception("Fallo la conexión");
      }
    } catch (e) {
      print("Error de sincronización: $e");
    }
  }

  // Guardar datos localmente
  Future<void> saveDataLocally(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/plantas.json');
    await file.writeAsString(data);
  }

  // Cargar datos desde el almacenamiento local
  Future<void> loadLocalData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/plantas.json');
    
    if (await file.exists()) {
      final data = await file.readAsString();
      setState(() {
        plantas = (json.decode(data) as List).map((json) => Plants.fromJson(json)).toList();
        // Al cargar los datos, NO inicializamos plantasFiltradas aquí
        // Se inicializará cuando se haga la primera búsqueda.
      });
      print("data cargada");
    } else {
      print("No se encontraron datos locales.");
      showErrorMessage(); // Mostrar mensaje si no hay datos locales
    }
  }

  // Mostrar mensaje de error si no hay internet
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

  @override
  void initState() {
    super.initState();
    checkSync(); // Verificar y sincronizar al iniciar
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filtrarPlantas(String query) {
    setState(() {
      busqueda = query;
      selectedIndex = null; // Resetear selección al escribir
      
      // Si la búsqueda no está vacía, mostramos la lista y filtramos
      if (query.isNotEmpty) {
        _mostrarLista = true; // Mostrar la lista al escribir
        plantasFiltradas = plantas.where((planta) {
          final nombreCompleto =
              "${planta.nombreComun ?? ''} ${planta.nombreCientifico ?? ''}".toLowerCase();
          return nombreCompleto.contains(query.toLowerCase());
        }).toList();
        plantasFiltradas.sort((a, b) => a.nombreComun!.compareTo(b.nombreComun!));
      } else {
        // Si el query está vacío, no se debe mostrar la lista por el momento
        // Solo se mostrará si se presiona el botón de búsqueda
        plantasFiltradas = []; // Vaciar la lista filtrada cuando el query es vacío
        _mostrarLista = false; // Ocultar la lista
      }
    });
  }

  // Función para manejar la búsqueda al presionar el icono
  void _handleSearchIconPressed() {
    setState(() {
      if (_mostrarLista) {
        // Si la lista está visible, la ocultamos y limpiamos la búsqueda
        _mostrarLista = false;
        _searchController.clear();
        busqueda = "";
        plantasFiltradas = []; // Vaciar la lista filtrada
      } else {
        // Si la lista está oculta, la mostramos con todas las plantas
        _mostrarLista = true;
        _searchController.clear(); // Asegúrate de que el campo esté vacío
        busqueda = "";
        plantas.sort((a, b) => a.nombreComun!.compareTo(b.nombreComun!));
        plantasFiltradas = plantas; // Mostrar todas las plantas
      }
      selectedIndex = null; // Reinicia la selección en ambos casos
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
                // Título decorativo
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
                        'assets/icons/buscar_nombre_icon.png',
                        height: 70,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Buscar por\nNombre",
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

                // Input de búsqueda
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
                    onChanged: (query) {
                      // Solo filtra si hay texto. Si se borra, no se muestra nada.
                      // La lista completa solo se mostrará al presionar el icono de búsqueda.
                      filtrarPlantas(query);
                    },
                    style: const TextStyle(fontSize: 17),
                    decoration: InputDecoration(
                      hintText: "Ingresa un nombre",
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _handleSearchIconPressed, // Llama a la nueva función
                      ),
                      contentPadding: const EdgeInsets.only(left: 20, top: 9, bottom: 10),
                    ),
                  ),
                ),

                const SizedBox(height: 1),

                // Lista de resultados filtrados (justo debajo del buscador)
                // Solo se muestra si _mostrarLista es true
                if (_mostrarLista)
                  plantasFiltradas.isEmpty && busqueda.isNotEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text("No se encontraron plantas"),
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
                                      color: esSeleccionado
                                          ? Colors.white
                                          : Colors.black,
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