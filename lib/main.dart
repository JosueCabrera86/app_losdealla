import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/info_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mano Entonada',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF660099)),
      ),
      initialRoute: '/splash', // pantalla inicial
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/info': (context) => const InfoScreen(),
        '/home': (context) => const HomeScreen(),
        '/loginYoga': (context) =>  LoginScreen(tipo: 'yoga'),
        '/loginCasino': (context) => LoginScreen(tipo: 'casino')
        // '/login': (context) => const LoginScreen(), // luego se agrega login
      },
    );
  }
}
