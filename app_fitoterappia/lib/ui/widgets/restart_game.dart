import 'package:app_fitoterappia/ui/pages/startup_memory_page.dart';
import 'package:app_fitoterappia/ui/widgets/game_controls_bottomsheet.dart';
import 'package:app_fitoterappia/ui/widgets/game_memory_button.dart';
import 'package:flutter/material.dart';

class RestartGame extends StatelessWidget {
  final VoidCallback pauseGame;
  final VoidCallback restartGame;
  final VoidCallback continueGame;
  final bool isGameOver;


  const RestartGame({
    Key? key,
    required this.isGameOver,
    required this.pauseGame,
    required this.restartGame,
    required this.continueGame,
  }): super(key: key);


  Future<void> showGameControls(BuildContext context) async {
    pauseGame();
    var value = await showModalBottomSheet<bool>(
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (sheetContext) {
        return const GameControlsBottomSheet();
      },
    );

    value ??= false;

    if (value) {
      restartGame();
    } else {
      continueGame();
    }
  }


  @override
  Widget build(BuildContext context) {
    if(isGameOver){
      return GameMemoryButton(
        title: "INTENTAR NUEVAMENTE", 
        onPressed: (){
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context){
            return const StartUpPage();
          }));
        },
        color: Colors.green[700]!,
      );
    }else{
      return GameMemoryButton(
        title: "PAUSAR", 
        onPressed: ()=>showGameControls(context), 
        color: Colors.green[700]!,
      );
    }
  }
}