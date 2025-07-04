import 'package:flutter/material.dart';

import 'package:app_fitoterappia/ui/widgets/game_options.dart';
import 'package:app_fitoterappia/ui/utils/constants.dart';

class StartUpPage extends StatelessWidget {
  const StartUpPage({super.key});

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
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  gameTitle,
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                GameOptions(),
              ]),
        ),
      ),
    );
  }
}