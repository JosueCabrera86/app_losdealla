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
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _showContent = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    final imageSize = isLandscape ? size.width * 0.25 : size.width * 0.35;
    final padding = isLandscape ? 32.0 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFFEDCBF6),
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        title: const Text(
          'Material Adicional',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFF4B0082),
        elevation: 4,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¡Nos da mucho gusto que estés aquí!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: colorPurple,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Te damos la bienvenida a este espacio que ha sido creado para que puedas complementar y dar continuidad a tu práctica.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.04,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,

                ),
              ),
              const SizedBox(height: 40),

              if (isLandscape)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildOption(
                        context,
                        image: 'assets/images/yoga_facial.jpg',
                        label: 'Yoga Facial',
                        width: imageSize,
                        route: '/loginYoga',
                        alignBottom: true, // 🔸 Centra visualmente
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildOption(
                        context,
                        image: 'assets/images/casino.jpg',
                        label: 'Formación de profesores\nCasino (Salsa Cubana)',
                        width: imageSize,
                        route: '/loginCasino',
                        alignBottom: true,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildOption(
                      context,
                      image: 'assets/images/yoga_facial.jpg',
                      label: 'Yoga Facial',
                      width: imageSize,
                      route: '/loginYoga',
                    ),
                    const SizedBox(height: 30),
                    _buildOption(
                      context,
                      image: 'assets/images/casino.jpg',
                      label:
                      'Formación de profesores\nCasino (Salsa Cubana)',
                      width: imageSize,
                      route: '/loginCasino',
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, {
        required String image,
        required String label,
        required double width,
        required String route,
        bool alignBottom = false,
      }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment:
      alignBottom ? MainAxisAlignment.center : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
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
              onTap: () => Navigator.pushNamed(context, route),
              splashColor: Colors.purple.withOpacity(0.2),
              highlightColor: Colors.purple.withOpacity(0.1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
                  width: width,
                  height: width,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: width * 0.11,
            color: const Color(0xFF660099),
          ),
        ),
      ],
    );
  }
}
