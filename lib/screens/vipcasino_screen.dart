
import 'package:app_losdealla/screens/modales_casino.dart';
import 'package:flutter/material.dart';

class VipCasinoScreen extends StatefulWidget {
  const VipCasinoScreen({super.key});

  @override
  State<VipCasinoScreen> createState() => _VipCasinoScreenState();
}

class _VipCasinoScreenState extends State<VipCasinoScreen> {
  int nivelUsuario = 0;
  bool loading = true;
  String error = '';
  Map<String, List<Map<String, dynamic>>> material = {
    'basico': [],
    'principiante': [],
    'intermedio': [],
    'avanzado': [],
  };

  @override
  void initState() {
    super.initState();
    fetchMaterial();
  }

  Future<void> fetchMaterial() async {
    final token = ''; // Aquí usarías SecureStorage o SharedPreferences
    if (token.isEmpty) {
      setState(() {
        error = 'No estás autorizado. Por favor inicia sesión.';
        loading = false;
      });
      return;
    }

    try {
      // Simulación de fetch desde tu backend
      // Reemplaza con tu llamada http real
      final data = {
        'nivel': 4,
        'materialBasico': [
          {
            'categoria': 1,
            'tipo': 'video',
            'title': 'Bases',
            'video': 'https://www.youtube.com/embed/u2OEmNMYTCw'
          },
          {
            'categoria': 1,
            'tipo': 'video',
            'title': 'Vueltas',
            'video': 'https://www.youtube.com/embed/K4bLW4_-w9Q'
          },
        ],
        'materialPrincipiante': [],
        'materialIntermedio': [],
        'materialAvanzado': [],
      };

      setState(() {
        nivelUsuario = (data['nivel'] ?? 0) as int;

        material['basico'] = List<Map<String, dynamic>>.from(
          ((data['materialBasico'] ?? []) as List)
              .where((item) => (item['categoria'] ?? 0) <= nivelUsuario),
        );

        material['principiante'] = List<Map<String, dynamic>>.from(
          ((data['materialPrincipiante'] ?? []) as List)
              .where((item) => (item['categoria'] ?? 0) <= nivelUsuario),
        );

        material['intermedio'] = List<Map<String, dynamic>>.from(
          ((data['materialIntermedio'] ?? []) as List)
              .where((item) => (item['categoria'] ?? 0) <= nivelUsuario),
        );

        material['avanzado'] = List<Map<String, dynamic>>.from(
          ((data['materialAvanzado'] ?? []) as List)
              .where((item) => (item['categoria'] ?? 0) <= nivelUsuario),
        );

        loading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error al conectar con el servidor: $e';
        loading = false;
      });
    }
  }

  void handleLogout() {
    // Limpiar token y volver al login
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero
            Stack(
              children: [
                Image.asset(
                  'assets/vipcasino/portada.jpg',
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 400,
                  color: Colors.black.withOpacity(0.6),
                ),
                Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'MATERIAL ADICIONAL',
                          style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Formación de Profesores de Casino',
                          style: TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '¡Hola! Te damos la bienvenida a este espacio creado para acompañar tu formación en Casino (Salsa cubana).',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.purple[400]),
              ),
            ),

            // Widgets por nivel
            if (nivelUsuario >= 1)
              NivelBasico(
                material: material['basico']!,
                nivelUsuario: nivelUsuario,
              ),

            if (nivelUsuario >= 2)
              NivelPrincipiante(
                material: material['principiante']!,
                nivelUsuario: nivelUsuario,
              ),

            if (nivelUsuario >= 3)
              NivelIntermedio(
                material: material['intermedio']!,
                nivelUsuario: nivelUsuario,
              ),

            if (nivelUsuario >= 4)
              NivelAvanzado(
                material: material['avanzado']!,
                nivelUsuario: nivelUsuario,
              ),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: handleLogout,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text('Cerrar sesión'),
            ),

            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(error, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
