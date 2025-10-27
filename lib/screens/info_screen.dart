import 'package:flutter/material.dart';
import 'dart:async';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF660099),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo_losdealla.png', width: 130),
                  const SizedBox(width: 16),
                  Image.asset('assets/images/logo_manoentonada.png', width: 120),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Material adicional\nRueda de conocimientos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Proyecto beneficiario del programa\nFARO del bienestar – FORACC 2025',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/escudoqroo.png', width: 130),
                  Transform.translate(
                    offset: const Offset(-19, 0),
                    child: Image.asset('assets/images/logo_sebien.png', width: 130),
                  ),
                  const SizedBox(width: 24),
                  Image.asset('assets/images/logo_faro.png', width: 70),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
