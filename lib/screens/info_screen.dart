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
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Escala dinámica según el ancho del dispositivo
          double scale = (constraints.maxWidth / 400).clamp(0.7, 1.2);
          bool isWide = constraints.maxWidth > 600; // Para tablets o landscape

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
                          Image.asset('assets/images/logo_losdealla.png', width: 130),
                          const SizedBox(width: 16),
                          Image.asset('assets/images/logo_manoentonada.png', width: 120),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Texto principal
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

                      // Texto secundario
                      const Text(
                        'Proyecto beneficiario del programa\nFARO del bienestar – FORACC 2025',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 32),

                      // Logos institucionales (adaptables)
                      if (!isWide)
                      // 📱 Versión móvil: todos en una fila
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.translate(
                              offset: const Offset(-7, 0),
                              child: Image.asset('assets/images/escudoqroo.png', width: 150),
                            ),
                            Transform.translate(
                              offset: const Offset(-40, 0),
                              child: Image.asset('assets/images/logo_sebien.png', width: 150),
                            ),
                            Transform.translate(
                              offset: const Offset(-20, 0),
                              child: Image.asset('assets/images/logo_faro.png', width: 50),
                            ),
                          ],
                        )
                      else
                      // 💻 Versión tablet / landscape: dos filas equilibradas
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.translate(
                                  offset: const Offset(-10, 0),
                                  child: Image.asset('assets/images/escudoqroo.png', width: 150),
                                ),
                                const SizedBox(width: 20),
                                Transform.translate(
                                  offset: const Offset(-20, 0),
                                  child: Image.asset('assets/images/logo_sebien.png', width: 150),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Transform.translate(
                              offset: const Offset(0, 0),
                              child: Image.asset('assets/images/logo_faro.png', width: 50),
                            ),
                          ],
                        ),
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
