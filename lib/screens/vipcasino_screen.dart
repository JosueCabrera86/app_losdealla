import 'dart:convert';
import 'package:flutter/material.dart';
import 'modales_casino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

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
  String? modalAbierto;

  @override
  void initState() {
    super.initState();
    fetchNivelUsuario();
  }

  Future<void> fetchNivelUsuario() async {
    setState(() {
      loading = true;
      error = '';
    });

    final token = (await storage.read(key: 'token'))?.trim() ?? '';
    if (token.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login', arguments: {'tipo': 'casino'});
      return;
    }

    try {
      final uri = Uri.parse('https://backendlda.onrender.com/api/casino/material');
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        setState(() {
          error = 'Error del servidor: ${response.statusCode}';
          loading = false;
        });
        return;
      }

      final data = jsonDecode(response.body);
      final nivel = data['nivel'] as int? ?? 0;

      setState(() {
        nivelUsuario = nivel;
        loading = false;
      });

      print('🔹 Nivel usuario: $nivelUsuario');
    } catch (e) {
      setState(() {
        error = 'Error al conectar con el servidor: $e';
        loading = false;
      });
    }
  }

  void abrirModal(String tipo) => setState(() => modalAbierto = tipo);
  void cerrarModal() => setState(() => modalAbierto = null);

  void handleLogout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'rol');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/casino.png',
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Formación de Profesores de Casino',
                          style: TextStyle(
                            color: Colors.purpleAccent,
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
                '¡Hola! Te damos la bienvenida a este espacio creado para acompañar tu formación en Casino (Salsa cubana).',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.purple[400]),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                if (nivelUsuario >= 1)
                  ElevatedButton(
                      onPressed: () => abrirModal('basico'), child: const Text('Nivel Básico')),
                if (nivelUsuario >= 2)
                  ElevatedButton(
                      onPressed: () => abrirModal('principiante'),
                      child: const Text('Nivel Principiante')),
                if (nivelUsuario >= 3)
                  ElevatedButton(
                      onPressed: () => abrirModal('intermedio'),
                      child: const Text('Nivel Intermedio')),
                if (nivelUsuario >= 4)
                  ElevatedButton(
                      onPressed: () => abrirModal('avanzado'), child: const Text('Nivel Avanzado')),
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
            // Modales
            if (modalAbierto == 'basico')
              NivelBasico(nivelUsuario: nivelUsuario, material: [], onClose: cerrarModal),
            if (modalAbierto == 'principiante')
              NivelPrincipiante(nivelUsuario: nivelUsuario, material: [], onClose: cerrarModal),
            if (modalAbierto == 'intermedio')
              NivelIntermedio(nivelUsuario: nivelUsuario, material: [], onClose: cerrarModal),
            if (modalAbierto == 'avanzado')
              NivelAvanzado(nivelUsuario: nivelUsuario, material: [], onClose: cerrarModal),
          ],
        ),
      ),
    );
  }
}
