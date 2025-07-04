import 'dart:async'; // Importa para usar Timer
import 'package:app_fitoterappia/ui/widgets/crosswordWidget.dart';
import 'package:flutter/material.dart';
// Importa el nuevo widget del temporizador
import 'package:app_fitoterappia/ui/widgets/game_crossword_timer.dart';

class CrosswordMatchPage extends StatefulWidget {
  const CrosswordMatchPage({super.key});

  @override
  State<CrosswordMatchPage> createState() => _CrosswordMatchPageState();
}

class _CrosswordMatchPageState extends State<CrosswordMatchPage> {
  Timer? _timer;
  int _timeElapsed = 0; // Almacena el tiempo transcurrido
  bool _isGameOver = false; // Indica si el juego ha terminado

  // Una clave para forzar la reconstrucción de Crosswordwidget al reiniciar el juego
  Key _crosswordKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _startTimer(); // Inicia el temporizador al iniciar la página
  }

  // Método para iniciar/reiniciar el temporizador
  void _startTimer() {
    _timeElapsed = 0; // Reinicia el tiempo
    _isGameOver = false; // Asegura que el juego no esté marcado como terminado
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _timeElapsed++; // Incrementa el tiempo cada segundo
      });
    });
  }

  // Callback que se llama cuando la sopa de letras se completa
  void _onGameComplete() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel(); // Detiene el temporizador
      setState(() {
        _isGameOver = true; // Marca el juego como terminado
      });
      print('Juego completado en $_timeElapsed segundos!');
      // Aquí puedes añadir lógica para mostrar un mensaje de felicitación
      // o navegar a otra pantalla de resultados.
    }
  }

  // Método para reiniciar el juego
  void _resetGame() {
    if (_timer != null) {
      _timer!.cancel(); // Cancela el temporizador actual
    }
    setState(() {
      // Cambia la clave del Crosswordwidget para forzar su reconstrucción
      // y así reiniciar el juego de la sopa de letras
      _crosswordKey = UniqueKey();
      _startTimer(); // Reinicia el temporizador
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancela el temporizador cuando el widget se elimina
    super.dispose();
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
            Navigator.pop(context); // Vuelve a la pantalla anterior
          },
        ),
        title: Image.asset(
          'assets/logos/logo_menu.png', // Logo de la aplicación.
          height: 90,
        ),
      ),
      body: Column( // Usa Column para organizar los elementos verticalmente
        children: [
          // Título de la sopa de letras
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                '🌿 Sopa de Letras',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Sopa de letras y palabras a marcar dentro de un Expanded para que ocupe el espacio disponible
          Expanded(
            child: Container(
              alignment: Alignment.center,
              // El Crosswordwidget ahora se encarga de su propio diseño flexible internamente
              child: Crosswordwidget(
                key: _crosswordKey, // Asigna la clave para el reinicio
                onGameComplete: _onGameComplete, // Pasa el callback de completado
              ),
            ),
          ),

        ],
      ),
    );
  }
}