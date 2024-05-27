import 'package:dispensador/screens/bluetooth_screen.dart';
import 'package:dispensador/screens/home_screen.dart';
import 'package:dispensador/screens/mascota_registrer.dart';
import 'package:dispensador/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dispenasdor de Alimentos',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        "/home": (context) => const HomeScreen(),
        "/mascotaRegister": (context) => const MascotaRegistrer(),
        "/bluethooth": (context) => BluetoothApp(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
