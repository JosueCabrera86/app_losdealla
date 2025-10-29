import 'package:flutter/material.dart';
import 'modales_yoga.dart'; // RutinasScreen, MasajesScreen, ClasesExtraScreen
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SuscriptoresYFScreen extends StatefulWidget {
  const SuscriptoresYFScreen({super.key});

  @override
  State<SuscriptoresYFScreen> createState() => _SuscriptoresYFScreenState();
}

class _SuscriptoresYFScreenState extends State<SuscriptoresYFScreen> {
  final storage = const FlutterSecureStorage();

  int nivelUsuario = 0;
  List<String> rutinas = [];
  List<String> masajes = [];
  List<String> clases = [];
  String? modalAbierto;
  String? error;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    fetchMaterial();
  }

  Future<void> fetchMaterial() async {
    setState(() {
      cargando = true;
      error = null;
    });

    final token = (await storage.read(key: 'token'))?.trim() ?? '';
    print('🔹 Token leido en SuscriptoresYFScreen: $token');

    if (token.isEmpty) {
      setState(() {
        error = "No estás autorizado. Por favor inicia sesión.";
        cargando = false;
      });
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login', arguments: {'tipo': 'yoga'});
      });
      return;
    }

    try {
      final uri = Uri.parse("https://backendlda.onrender.com/api/yoga-facial/material");
      final response = await http.get(uri, headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('🔹 Datos recibidos del backend: $data');

        final nivel = data['nivel'] ?? 0;
        final material = (data['material'] ?? []) as List;

        // Filtrar y separar material según palabras clave
        final filteredMaterial = material
            .map((e) => e.toString().trim())
            .where((e) => e.isNotEmpty)
            .toList();

        final rutinasData = filteredMaterial
            .where((item) => item.toLowerCase().contains('clase'))
            .toList();

        final masajesData = filteredMaterial
            .where((item) => item.toLowerCase().contains('masaje'))
            .toList();

        final clasesData = filteredMaterial
            .where((item) => item.toLowerCase().contains('introducción') || item.toLowerCase().contains('intro'))
            .toList();

        setState(() {
          nivelUsuario = nivel;
          rutinas = rutinasData;
          masajes = masajesData;
          clases = clasesData;
          cargando = false;
        });

        print('🔹 Nivel usuario: $nivelUsuario');
        print('🔹 Material Rutinas: $rutinas');
        print('🔹 Material Masajes: $masajes');
        print('🔹 Material Clases: $clases');
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          error = data['error'] ?? data['message'] ?? "Error al cargar material.";
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Error al conectar con el servidor: $e";
        cargando = false;
      });
    }
  }

  void abrirModal(String tipo) => setState(() => modalAbierto = tipo);
  void cerrarModal() => setState(() => modalAbierto = null);

  bool get puedeVerRutinas => rutinas.isNotEmpty;
  bool get puedeVerMasajes => masajes.isNotEmpty;
  bool get puedeVerClases => clases.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🌄 Portada
            Stack(
              children: [
                Image.asset(
                  'assets/images/face_yoga_portada.jpg',
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 400,
                  color: Colors.black.withOpacity(0.4),
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'MATERIAL ADICIONAL',
                        style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(blurRadius: 4, color: Colors.black45, offset: Offset(2,2))],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Yoga Facial',
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          shadows: [Shadow(blurRadius: 4, color: Colors.black45, offset: Offset(2,2))],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '¡Hola, nos da mucho gusto que estés aquí! Este espacio ha sido creado para que continúes con tus sesiones de Yoga Facial.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.deepPurple[400]),
              ),
            ),

            const SizedBox(height: 24),

            if (error != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),

            if (modalAbierto == null)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  if (puedeVerRutinas)
                    ElevatedButton(
                      onPressed: () => abrirModal('rutinas'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple[100]),
                      child: const Text('Rutinas de Yoga Facial'),
                    ),
                  if (puedeVerMasajes)
                    ElevatedButton(
                      onPressed: () => abrirModal('masajes'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple[100]),
                      child: const Text('Masajes previos a tu rutina'),
                    ),
                  if (puedeVerClases)
                    ElevatedButton(
                      onPressed: () => abrirModal('clases'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple[100]),
                      child: const Text('Clases extra'),
                    ),
                ],
              ),

            if (modalAbierto == 'rutinas')
              RutinasScreen(material: rutinas, nivelUsuario: nivelUsuario, onClose: cerrarModal),
            if (modalAbierto == 'masajes')
              MasajesScreen(material: masajes, nivelUsuario: nivelUsuario, onClose: cerrarModal),
            if (modalAbierto == 'clases')
              ClasesExtraScreen(material: clases, nivelUsuario: nivelUsuario, onClose: cerrarModal),
          ],
        ),
      ),
    );
  }
}
