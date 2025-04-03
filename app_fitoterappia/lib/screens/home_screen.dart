import 'package:app_fitoterappia/screens/menu_screen.dart';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../components/custom_button.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logos/logo_home.png', // Asegúrate de que la imagen está en assets
              height: 200,
            ),
            // const SizedBox(height: 20),
            // const Text(
            //   "fitoterappia",
            //   style: TextStyle(
            //     fontSize: 50,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            const SizedBox(height: 60),
            CustomButton(
              text: "Comenzar",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
