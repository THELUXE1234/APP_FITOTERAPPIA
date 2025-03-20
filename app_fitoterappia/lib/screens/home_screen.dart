import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 60,
            width: double.infinity,
            child: ElevatedButton(onPressed: (){}, child: Text("hola"))),
        ),
        Spacer(),
      ],
    );
  }
}