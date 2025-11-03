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

    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDCBF6),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double scale = (constraints.maxWidth / 400).clamp(0.7, 1.2);
          bool isWide = constraints.maxWidth > 600;

          return Center(
            child: SingleChildScrollView(
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logos superiores
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/logo_losdeallac.png', width: 130),
                          const SizedBox(width: 60),
                          Image.asset('assets/images/logo_manoentonadaa.png', width: 130),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Texto principal
                      const Text(
                        'Material adicional\nRueda de conocimientos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Texto secundario
                      const Text(
                        'Proyecto beneficiario del programa\nFARO del bienestar – FORACC 2025',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 15),
                      ),
                      SizedBox(height: isWide ? 70 : 50),

                      // 🔹 Logos institucionales — misma fila en ambas versiones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Transform.translate(
                            offset: const Offset(-7, 0),
                            child: Image.asset(
                              'assets/images/escudoqroo.png',
                              width: isWide ? 150 : 150,
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(-40, 0),
                            child: Image.asset(
                              'assets/images/logo_sebien.png',
                              width: isWide ? 150 : 150,
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(-22, -0.5),
                            child: Image.asset(
                              'assets/images/logo_faron.png',
                              width: isWide ? 60 : 60,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isWide ? 60 : 40),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
