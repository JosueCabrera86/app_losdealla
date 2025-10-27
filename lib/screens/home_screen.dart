import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _showContent = false;
  final Color colorPurple = const Color(0xFF660099);

  @override
  void initState() {
    super.initState();
    // Pequeño retardo para la animación inicial
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _showContent = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Material Adicional'),
        backgroundColor: colorPurple,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🟢 Mensaje de bienvenida
              const Text(
                '¡Hola, nos da mucho gusto que estés aquí!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF660099),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Te damos la bienvenida a este espacio que ha sido creado para que puedas complementar y dar continuidad a tu práctica.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 40),


              const SizedBox(height: 32),

              // 🟣 Opciones: Yoga Facial / Casino
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🧘 Yoga Facial
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedOpacity(
                        opacity: _showContent ? 1 : 0,
                        duration: const Duration(seconds: 1),
                        child: AnimatedScale(
                          scale: _showContent ? 1 : 0.8,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOutBack,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {

                              Navigator.pushNamed(context, '/loginYoga');

                            },
                            splashColor: Colors.purple.withOpacity(0.2),
                            highlightColor: Colors.purple.withOpacity(0.1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/yoga_facial.jpg',
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Yoga Facial',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF660099),
                        ),
                      ),
                    ],
                  ),

                  // 💃 Casino
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedOpacity(
                        opacity: _showContent ? 1 : 0,
                        duration: const Duration(seconds: 1),
                        child: AnimatedScale(
                          scale: _showContent ? 1 : 0.8,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOutBack,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                             Navigator.pushNamed(context, '/loginCasino');

                            },
                            splashColor: Colors.purple.withOpacity(0.2),
                            highlightColor: Colors.purple.withOpacity(0.1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/casino.png',
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Formación de profesores\nCasino (Salsa Cubana)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF660099),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
