import 'package:flutter/material.dart';

class GameCrosswordTimer extends StatelessWidget {
  final int time;
  const GameCrosswordTimer({
    Key? key,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(40),
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.green[800], // Color de fondo del temporizador
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Expanded(
              flex: 1,
              child: Icon(
                Icons.timer,
                size: 40,
                color: Colors.black, // Color del icono para que sea visible
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  '${time}s', // Muestra el tiempo en segundos
                  style: const TextStyle(
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Color del texto para que sea visible
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
