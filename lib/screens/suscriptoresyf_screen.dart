import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'modales_yoga.dart'; // Importa tus widgets: MasajesScreen, RutinasScreen, ClasesExtraScreen

class SuscriptoresYFScreen extends StatefulWidget {
  const SuscriptoresYFScreen({super.key});

  @override
  State<SuscriptoresYFScreen> createState() => _SuscriptoresYFScreenState();
}

class _SuscriptoresYFScreenState extends State<SuscriptoresYFScreen> {
  Map<String, List<Map<String, dynamic>>> material = {
    'rutinas': [],
    'masajes': [],
    'clases': []
  };
  int nivelUsuario = 0;
  String error = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchMaterial();
  }

  Future<void> fetchMaterial() async {
    final token = ''; // Recupera tu token seguro
    if (token.isEmpty) {
      setState(() {
        error = 'No estás autorizado. Por favor inicia sesión.';
        loading = false;
      });
      return;
    }

    try {
      final uri = Uri.parse('https://backendlda.onrender.com/api/yoga-facial/material');
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode != 200) {
        setState(() {
          error = 'Error del servidor: ${response.statusCode}';
          loading = false;
        });
        return;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final nivel = data['nivel'] as int? ?? 0;

      List<Map<String, dynamic>> filtrar(List<dynamic>? items) {
        if (items == null) return [];
        return items
            .whereType<Map<String, dynamic>>()
            .where((item) => (item['categoria'] ?? 0) <= nivel)
            .toList();
      }

      setState(() {
        nivelUsuario = nivel;
        material = {
          'rutinas': filtrar(data['materialRutinas'] as List?),
          'masajes': filtrar(data['materialMasajes'] as List?),
          'clases': filtrar(data['materialClases'] as List?),
        };
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
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/faceyoga1.jpg',
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 400,
                  color: Colors.black.withOpacity(0.5),
                ),
                Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'MATERIAL ADICIONAL',
                          style: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Yoga Facial',
                          style: TextStyle(
                            color: Colors.pinkAccent,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
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
                '¡Hola! Bienvenido a este espacio para continuar tus sesiones de Yoga Facial.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.purple[400]),
              ),
            ),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                if (material['masajes']!.isNotEmpty)
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MasajesScreen(
                          material: material['masajes']!,
                          nivelUsuario: nivelUsuario,
                        ),
                      ),
                    ),
                    child: const Text('Masajes'),
                  ),
                if (material['rutinas']!.isNotEmpty)
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RutinasScreen(
                          material: material['rutinas']!,
                          nivelUsuario: nivelUsuario,
                        ),
                      ),
                    ),
                    child: const Text('Rutinas'),
                  ),
                if (material['clases']!.isNotEmpty)
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClasesExtraScreen(
                          material: material['clases']!,
                          nivelUsuario: nivelUsuario,
                        ),
                      ),
                    ),
                    child: const Text('Clases Extra'),
                  ),
              ],
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
