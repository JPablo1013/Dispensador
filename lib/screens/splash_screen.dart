import 'package:dispensador/screens/bluetooth_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:splash_view/source/presentation/presentation.dart';
import 'package:dispensador/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SplashView(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.white,
              Colors.blue,
            ]
            ),
          logo: Lottie.asset('assets/tecnm.json',
          height: MediaQuery.of(context).size.height * .5
          ),
          done: Done(HomeScreen()),
          //done: Done(BluetoothApp()),
          duration: const Duration(milliseconds: 6000),
          bottomLoading: true,
        )
    );
  }
}