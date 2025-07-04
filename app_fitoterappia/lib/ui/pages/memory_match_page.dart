import 'dart:async';

import 'package:app_fitoterappia/ui/pages/startup_memory_page.dart';
import 'package:app_fitoterappia/ui/widgets/restart_game.dart';
import 'package:flutter/material.dart';

import 'package:app_fitoterappia/models/Game_memory.dart';
import 'package:app_fitoterappia/ui/widgets/game_memory_timer.dart';

import '../widgets/memory_card.dart';

class MemoryMatchPage extends StatefulWidget {
  const MemoryMatchPage({
    required this.gameLevel,
    super.key,
  });
  final int gameLevel;
  @override
  State<MemoryMatchPage> createState() => _MemoryMatchPageState();
}

class _MemoryMatchPageState extends State<MemoryMatchPage> {
  Timer? timer;
  GameMemory? game;
  late Duration duration;
  @override
  void initState(){
    super.initState();
    game = GameMemory(widget.gameLevel);
    duration = const Duration();
    startTimer();
  }

  startTimer(){
    timer = Timer.periodic(const Duration(seconds: 1), (_){
      setState(() {
        final seconds = duration.inSeconds +1;
        duration =Duration(seconds: seconds);
      });
      if(game!.isGameOver){
        timer!.cancel();
      }
    });
  }

  pauseTimer(){
    timer!.cancel();
  }

  // Función para reiniciar el juego
  void _resetGame() {
    // Cancelar el timer si existe
    if (timer != null) {
      timer!.cancel();
    }
    
    game!.resetGame();
    setState(() {
      // Reiniciar el timer
      timer!.cancel();
      duration = const Duration();
      startTimer();
    });
  }

  @override
  void dispose() {
    // Asegurarse de cancelar el timer cuando el widget se elimine de la vista
    timer?.cancel();
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StartUpPage(), // Reemplaza con tu pantalla de inicio real
              ),
            );
          },
        ),
        title: Image.asset(
          'assets/logos/logo_menu.png',
          height: 90,
        ),
      ),
      body: SafeArea(
        child: Column(
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
                '🌿 Memorice Plantas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 30),
            Expanded(
              flex: 3,
              child: GridView.count(
                crossAxisCount: game!.gridSize,
                children: List.generate(game!.cards.length, (index){
                  return MemoryCard(
                    index: index,
                    cardItem: game!.cards[index],
                    onCardPressed: game!.onCardPressed,
                  );
                }),
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
               child: RestartGame(
                isGameOver: game!.isGameOver, 
                pauseGame: ()=>pauseTimer(), 
                restartGame: ()=>_resetGame(), 
                continueGame: ()=>startTimer(),
              ),
            ),

          ],
        )
      ),
    );
  }
}