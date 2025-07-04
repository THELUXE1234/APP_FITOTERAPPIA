import 'package:app_fitoterappia/ui/pages/memory_match_page.dart';
import 'package:app_fitoterappia/ui/widgets/game_memory_button.dart';
import 'package:flutter/material.dart';
import 'package:app_fitoterappia/ui/utils/constants.dart';

class GameOptions extends StatelessWidget {
  const GameOptions({
    Key? key,
  }): super(key: key);

  static Route<dynamic> _routeBuilder(BuildContext context, int gameLevel) {
    return MaterialPageRoute(
      builder: (_) {
        return MemoryMatchPage(gameLevel: gameLevel);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: gameLevels.map((level) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: GameMemoryButton(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                _routeBuilder(context, level['level']),
                (Route<dynamic> route) => false),
            title: level['title'],
            color: level['color']![700]!,
            width: 250,
          ),
        );
      }).toList(),
    );
  }
}