import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_fitoterappia/models/Glosario.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class GlosarioScreen extends StatefulWidget {
  const GlosarioScreen({super.key});

  @override
  State<GlosarioScreen> createState() => _GlosarioScreenState();
}

class _GlosarioScreenState extends State<GlosarioScreen> {
  List<Glosario> glosario = [];
  List<String> categories = [];
  List<Glosario> filteredGlosario = [];
  bool isListVisible = false; // Variable para manejar la visibilidad de la lista

  // Verificar si se debe hacer la sincronización (una vez por semana)
  Future<void> checkSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastGlosarioSyncDate');
    final lastSyncDate = prefs.getString('lastGlosarioSyncDate');
    final currentDate = DateTime.now().toString().split(' ')[0]; // Solo fecha (YYYY-MM-DD)

    if (lastSyncDate == null || lastSyncDate != currentDate) {
      await syncData(); // Si es la primera vez o ha pasado más de una semana, sincronizamos
    }
    await loadLocalData();
  }

  // Sincronizar datos desde la API
  Future<void> syncData() async {
    final apiUrl = dotenv.env['API_URL'];
    final uri = Uri.parse('$apiUrl/glosario');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Guardamos los datos localmente
        await saveDataLocally(response.body);
        print("listo");
        // Actualizamos la fecha de la última sincronización
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('lastGlosarioSyncDate', DateTime.now().toString().split(' ')[0]);
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
    final file = File('${directory.path}/glosario.json');
    await file.writeAsString(data);
  }

  // Cargar datos desde el almacenamiento local
  Future<void> loadLocalData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/glosario.json');

    if (await file.exists()) {
      final data = await file.readAsString();
      setState(() {
        glosario = (json.decode(data) as List)
            .map((json) => Glosario.fromJson(json))
            .toList();
        glosario.sort((a, b) => (a.term ?? '').compareTo(b.term ?? ''));

        // Extraer categorías únicas
        categories = glosario
            .map((item) => item.category ?? 'Sin categoría') // Asumiendo que 'category' es el campo de categoría
            .toSet()
            .toList();
      });
    } else {
      showErrorMessage();
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
    super.dispose();
  }

  // Construir los botones de categorías
  Widget buildCategoryButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0), // Ajuste el espaciado aquí
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Alineación centrada
        children: categories.map((category) {
          return _buildCategoryButton(category);
        }).toList(),
      ),
    );
  }

  // Crear un botón para cada categoría
  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            filteredGlosario = glosario
                .where((item) => item.category == category)
                .toList();
            isListVisible = true; // Mostrar la lista al seleccionar una categoría
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF59373e),
            borderRadius: BorderRadius.circular(90),
          ),
          child: Center(
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 17.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Construir la lista de términos y definiciones
Widget buildGlossaryList() {
  List<Glosario> dataToShow = filteredGlosario.isEmpty ? glosario : filteredGlosario;

  return GestureDetector(
    onTap: () {
      setState(() {
        isListVisible = false; // Cerrar la lista y mostrar los botones
      });
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8), // Bordes redondeados
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
            ),
          ],
        ),
        child: ListView.builder(
          padding: EdgeInsets.zero, // Eliminar el padding extra alrededor del ListView
          itemCount: dataToShow.length,
          itemBuilder: (context, index) {
            final item = dataToShow[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              elevation: 4,
              child: ListTile(
                title: Text(
                  item.term ?? "Sin nombre", // Nombre común
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  item.definition ?? "Sin definición", // Definición
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                isThreeLine: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              ),
            );
          },
        ),
      ),
    ),
  );
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
          'assets/logos/logo_menu.png', // Logo de la aplicación.
          height: 90,
        ),
      ),
      body: Center(
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/glosario_icon.png', // Icono del glosario
                      height: 70,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Glosario",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D813A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Usamos AnimatedSwitcher para transiciones suaves
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: isListVisible
                      ? buildGlossaryList() // Mostrar lista cuando esté visible
                      : buildCategoryButtons(), // Mostrar botones cuando no
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
