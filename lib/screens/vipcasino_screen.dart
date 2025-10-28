import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'modales_casino.dart';

class VipCasinoScreen extends StatefulWidget {
  const VipCasinoScreen({super.key});

  @override
  State<VipCasinoScreen> createState() => _VipCasinoScreenState();
}

class _VipCasinoScreenState extends State<VipCasinoScreen> {
  final storage = const FlutterSecureStorage();

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
    final token = await storage.read(key: 'token');
    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    setState(() => loading = true);

    try {
      final uri = Uri.parse('https://backendlda.onrender.com/api/casino/material');
      final response = await http.get(uri, headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'});

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
        return items.whereType<Map<String, dynamic>>().where((item) => (item['categoria'] ?? 0) <= nivel).toList();
      }

      setState(() {
        nivelUsuario = nivel;
        material['basico'] = filtrar(data['materialBasico'] as List?);
        material['principiante'] = filtrar(data['materialPrincipiante'] as List?);
        material['intermedio'] = filtrar(data['materialIntermedio'] as List?);
        material['avanzado'] = filtrar(data['materialAvanzado'] as List?);
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error al conectar con el servidor: $e';
        loading = false;
      });
    }
  }

  void handleLogout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'rol');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HERO
            Stack(
              children: [
                Image.asset('assets/vipcasino/portada.jpg', width: double.infinity, height: 400, fit: BoxFit.cover),
                Container(width: double.infinity, height: 400, color: Colors.black.withOpacity(0.6)),
                Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('MATERIAL ADICIONAL', style: TextStyle(color: Colors.cyanAccent, fontSize: 32, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Formación de Profesores de Casino', style: TextStyle(color: Colors.purpleAccent, fontSize: 28, fontWeight: FontWeight.bold)),
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

            if (nivelUsuario >= 1) NivelBasico(material: material['basico']!, nivelUsuario: nivelUsuario),
            if (nivelUsuario >= 2) NivelPrincipiante(material: material['principiante']!, nivelUsuario: nivelUsuario),
            if (nivelUsuario >= 3) NivelIntermedio(material: material['intermedio']!, nivelUsuario: nivelUsuario),
            if (nivelUsuario >= 4) NivelAvanzado(material: material['avanzado']!, nivelUsuario: nivelUsuario),

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
