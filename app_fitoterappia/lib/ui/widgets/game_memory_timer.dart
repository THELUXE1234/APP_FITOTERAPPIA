import 'package:flutter/material.dart';

class GameMemoryTimer extends StatelessWidget {
  final int time;
  const GameMemoryTimer({
    Key? key,
    required this.time,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    final minutes = (time ~/ 60).toString().padLeft(2, '0');
    final seconds = (time % 60).toString().padLeft(2, '0');
    return Card(
      margin: const EdgeInsets.all(40),
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.green[800],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Expanded(
              flex: 1,
              child: Icon(
                Icons.timer,
                size: 40,
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  '$minutes:$seconds',
                  style: const TextStyle(
                    fontSize: 28.0, 
                    fontWeight: FontWeight.bold,
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