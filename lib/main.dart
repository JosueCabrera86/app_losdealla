import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

import 'screens/splash_screen.dart';
import 'screens/info_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'package:app_losdealla/screens/suscriptoresyf_screen.dart';
import 'package:app_losdealla/screens/vipcasino_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );


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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEDCBF6),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/info': (context) => const InfoScreen(),
        '/home': (context) => const HomeScreen(),
        '/loginYoga': (context) => LoginScreen(tipo: 'yoga'),
        '/loginCasino': (context) => LoginScreen(tipo: 'casino'),
        '/suscriptoresyf': (context) => SuscriptoresYFScreen(),
        '/vipcasino': (context) => VipCasinoScreen(),
      },
    );
  }
}
