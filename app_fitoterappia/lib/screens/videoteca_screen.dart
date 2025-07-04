import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// ¡OJO! Asegúrate que el nombre del archivo del modelo sea correcto. 
// Si lo llamaste video_model.dart, el import debe ser:
import 'package:app_fitoterappia/models/videos.dart'; 

class VideotecaScreen extends StatefulWidget {
  const VideotecaScreen({super.key});

  @override
  State<VideotecaScreen> createState() => _VideotecaScreenState();
}

class _VideotecaScreenState extends State<VideotecaScreen> {
  List<Video> videos = []; 
  bool _isLoading = true; 

  final List<YoutubePlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    checkSync();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // --- LÓGICA DE SINCRONIZACIÓN Y DATOS LOCALES ---

  Future<void> checkSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastVideoSyncDate');
    final lastSyncDate = prefs.getString('lastVideoSyncDate');
    final currentDate = DateTime.now().toString().split(' ')[0];

    if (lastSyncDate == null || lastSyncDate != currentDate) {
      await syncData(); 
    }
    await loadLocalData();
  }

  Future<void> syncData() async {
    final apiUrl = dotenv.env['API_URL'];
    final uri = Uri.parse('$apiUrl/videos');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        await saveDataLocally(response.body);
        print("Datos de videos sincronizados correctamente.");
        
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('lastVideoSyncDate', DateTime.now().toString().split(' ')[0]);
      } else {
        throw Exception("Fallo la conexión con el servidor de videos");
      }
    } catch (e) {
      print("Error de sincronización de videos: $e");
    }
  }

  Future<void> saveDataLocally(String data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/videos.json');
    await file.writeAsString(data);
  }

  Future<void> loadLocalData() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/videos.json');

    if (await file.exists()) {
      final data = await file.readAsString();
      final loadedVideos = videosFromJson(data);
      
      setState(() {
        videos = loadedVideos;

        for (var controller in _controllers) {
          controller.dispose();
        }
        _controllers.clear();

        // --- CAMBIO 1: Lógica mejorada para crear controladores ---
        for (var video in videos) {
          // Usamos la utilidad para convertir la URL a ID.
          // `?? ''` previene errores si el link es nulo.
          final videoId = YoutubePlayer.convertUrlToId(video.link ?? '');

          // Solo creamos el controlador si obtuvimos un ID válido
          if (videoId != null && videoId.isNotEmpty) {
            _controllers.add(
              YoutubePlayerController(
                initialVideoId: videoId, // <-- Usamos el ID extraído
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                  isLive: false,
                ),
              ),
            );
          } else {
            // Opcional: si un video no tiene link válido, puedes decidir qué hacer.
            // Por ahora, simplemente no se añade a la lista de reproductores.
             print("ID de video inválido o nulo para el título: ${video.title}");
          }
        }
        
        _isLoading = false;
      });
      print("Datos de videos cargados desde el almacenamiento local.");
    } else {
      print("No se encontraron datos locales de videos.");
      setState(() {
        _isLoading = false;
      });
      showErrorMessage();
    }
  }

  void showErrorMessage() {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Sin Conexión o Datos"),
          content: const Text("No se pudieron cargar los videos. Por favor, revisa tu conexión a internet e inténtalo de nuevo."),
          actions: <Widget>[
            TextButton(
              child: const Text("Aceptar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  // --- CONSTRUCCIÓN DE LA INTERFAZ ---

  Widget _buildVideoCard(Video video, YoutubePlayerController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          YoutubePlayer(
            controller: controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.amber,
            progressColors: const ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amberAccent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              // --- CAMBIO 2: Corregido para mostrar el título real ---
              video.title ?? 'Sin Título', // Usamos el valor de la propiedad
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(
          'assets/logos/logo_menu.png',
          height: 90,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          // --- CAMBIO 3: Usamos la longitud de _controllers para el itemCount ---
          // Esto asegura que solo intentemos construir widgets para videos con ID válido.
          : _controllers.isEmpty
              ? const Center(child: Text("No hay videos disponibles."))
              : SingleChildScrollView(
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
                                'assets/icons/videoteca_icon.png',
                                height: 70,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Videoteca",
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
                        
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _controllers.length, // <-- Usamos la lista de controladores
                          itemBuilder: (context, index) {
                            // Asumimos que el video en el mismo índice corresponde al controlador
                            final video = videos[index]; 
                            final controller = _controllers[index];
                            return _buildVideoCard(video, controller);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}