import 'package:flutter/material.dart';
import 'modales_yoga.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_losdealla/data/material_base.dart';

class SuscriptoresYFScreen extends StatefulWidget {
  const SuscriptoresYFScreen({super.key});

  @override
  State<SuscriptoresYFScreen> createState() => _SuscriptoresYFScreenState();
}

class _SuscriptoresYFScreenState extends State<SuscriptoresYFScreen> {
  final storage = const FlutterSecureStorage();
  int nivelUsuario = 0;
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
        final nivel = data['nivel'] ?? 0;
        setState(() {
          nivelUsuario = nivel;
          cargando = false;
        });
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final rutinasPermitidas = rutinasBase
        .where((item) => item['categoria'] <= nivelUsuario)
        .map((e) => e['title'].toString())
        .toList();
    final masajesPermitidos = masajesBase
        .where((item) => item['categoria'] <= nivelUsuario)
        .map((e) => e['title'].toString())
        .toList();
    final clasesPermitidas = clasesBase
        .where((item) => item['categoria'] <= nivelUsuario)
        .map((e) => e['title'].toString())
        .toList();

    final secciones = [
      if (rutinasPermitidas.isNotEmpty)
        {
          'titulo': 'Rutinas de Yoga Facial',
          'tipo': 'rutinas',
          'imagen': 'assets/images/rutinas.jpg',
          'alignment': Alignment (0,-0.4),
        },
      if (masajesPermitidos.isNotEmpty)
        {
          'titulo': 'Masajes previos a tu rutina',
          'tipo': 'masajes',
          'imagen': 'assets/images/masajes.jpg',
          'alignment': Alignment (0,-0.4),
        },
      if (clasesPermitidas.isNotEmpty)
        {
          'titulo': 'Clases extra',
          'tipo': 'clases',
          'imagen': 'assets/images/clases.jpg',
          'alignment': Alignment(0,-0.4),
        },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🌄 Portada principal
            Stack(
              children: [
                Image.asset(
                  'assets/images/face_yoga_portada.jpg',
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  color: Colors.black.withOpacity(0.4),
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'MATERIAL ADICIONAL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Yoga Facial',
                        style: TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '¡Hola! Este espacio ha sido creado para que continúes con tus sesiones de Yoga Facial y profundices tu práctica.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.deepPurple[400]),
              ),
            ),
            const SizedBox(height: 20),

            if (error != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),

            // 🌸 Tarjetas visuales
            if (modalAbierto == null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: secciones.map((sec) {
                    final titulo = sec['titulo'] as String;
                    final tipo = sec['tipo'] as String;
                    final imagen = sec['imagen'] as String;
                    final alignment = sec['alignment'] as Alignment;

                    return AnimatedScale(
                      scale: 1,
                      duration: const Duration(milliseconds: 200),
                      child: GestureDetector(
                        onTapUp: (_) => abrirModal(tipo),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          width: width * 0.9,
                          height: 140,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            image: DecorationImage(
                              image: AssetImage(imagen),
                              fit: BoxFit.cover,
                              alignment: alignment,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.45),
                                BlendMode.darken,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            titulo,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            // 🌿 Modales según tipo
            if (modalAbierto == 'rutinas')
              RutinasScreen(
                material: rutinasPermitidas,
                nivelUsuario: nivelUsuario,
                onClose: cerrarModal,
              ),
            if (modalAbierto == 'masajes')
              MasajesScreen(
                material: masajesPermitidos,
                nivelUsuario: nivelUsuario,
                onClose: cerrarModal,
              ),
            if (modalAbierto == 'clases')
              ClasesExtraScreen(
                material: clasesPermitidas,
                nivelUsuario: nivelUsuario,
                onClose: cerrarModal,
              ),
          ],
        ),
      ),
    );
  }
}
