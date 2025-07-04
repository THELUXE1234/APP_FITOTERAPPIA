import 'package:app_fitoterappia/ui/pages/startup_memory_page.dart';
import 'package:app_fitoterappia/ui/utils/constants.dart';
import 'package:app_fitoterappia/ui/widgets/game_memory_button.dart';
import 'package:flutter/material.dart';




class GameControlsBottomSheet extends StatelessWidget {
  const GameControlsBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'PAUSAR',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
          const SizedBox(height: 10),
          GameMemoryButton(
            onPressed: () => Navigator.of(context).pop(false),
            title: 'CONTINUAR',
            color: continueButtonColor,
            width: 200,
          ),
          const SizedBox(height: 10),
          GameMemoryButton(
            onPressed: () => Navigator.of(context).pop(true),
            title: 'REINICIAR',
            color: restartButtonColor,
            width: 200,
          ),
          const SizedBox(height: 10),
          GameMemoryButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const StartUpPage();
                  },
                ),
                (Route<dynamic> route) => false,
              );
            },
            title: 'SALIR',
            color: quitButtonColor,
            width: 200,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}