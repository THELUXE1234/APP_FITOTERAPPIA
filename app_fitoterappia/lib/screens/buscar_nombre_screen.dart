import 'dart:convert';
import 'package:app_fitoterappia/models/Plants.dart';
import 'package:app_fitoterappia/screens/detalle_planta_screen.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<void> getPlantas() async {
    final uri = Uri.parse("http://10.0.2.2:5000/api/plantas");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      setState(() {
        plantas = data.map((json) => Plants.fromJson(json)).toList();
      });
    } else {
      throw Exception("Fallo la conexión");
    }
  }

  void filtrarPlantas(String query) {
    setState(() {
      busqueda = query;
      selectedIndex = null; // Resetear selección al escribir
      if (query.isEmpty) {
        plantasFiltradas = [];
      } else {
        plantasFiltradas = plantas.where((planta) {
          final nombreCompleto =
              "${planta.nombreComun ?? ''} ${planta.nombreCientifico ?? ''}".toLowerCase();
          return nombreCompleto.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getPlantas();
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
                const SizedBox(height: 80),
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
                        color: Colors.black.withOpacity(0.6), // Sombra suave
                        blurRadius: 8, // Radio de difuminado de la sombra
                        offset: const Offset(0, 4), // Desplazamiento de la sombra
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: filtrarPlantas,
                    style: const TextStyle(fontSize: 17),
                    decoration: const InputDecoration(
                      hintText: "Ingresa un nombre",
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search),
                      contentPadding: EdgeInsets.only(left: 20, top: 9, bottom: 10),
                    ),
                  ),
                ),

                const SizedBox(height: 1),

                // Lista de resultados filtrados (justo debajo del buscador)
                if (busqueda.isNotEmpty)
                  plantasFiltradas.isEmpty
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
                                    // Aquí va tu redirección a vista inicial
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetallePlantaScreen(planta: planta),
                                        )
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
