import 'package:flutter/material.dart';
import 'modales_yoga.dart';
import 'package:app_losdealla/data/material_base.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class SuscriptoresYFScreen extends StatefulWidget {
  const SuscriptoresYFScreen({super.key});

  @override
  State<SuscriptoresYFScreen> createState() => _SuscriptoresYFScreenState();
}

class _SuscriptoresYFScreenState extends State<SuscriptoresYFScreen> {

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

    try {
      final supabase = Supabase.instance.client;

      // 1️⃣ Verificar sesión activa
      final session = supabase.auth.currentSession;

      if (session == null) {
        setState(() {
          error = "Sesión no válida. Cierra e inicia sesión nuevamente.";
          cargando = false;
        });
        return;
      }

      // 2️⃣ Obtener email del usuario
      final email = session.user.email!;

      // 3️⃣ Obtener categoría desde Supabase
      final response = await supabase
          .from('users')
          .select('categoria')
          .eq('email', email)
          .single();

      setState(() {
        nivelUsuario = response['categoria'] ?? 0;
        cargando = false;
      });
    } on PostgrestException catch (e) {
      setState(() {
        error = e.message;
        cargando = false;
      });
    } catch (e, stack) {
  debugPrint('LOGIN ERROR: $e');
  debugPrint('STACK: $stack');

  setState(() {
  error = e.toString();
  });
}

}

  void abrirModal(String tipo) => setState(() => modalAbierto = tipo);
  void cerrarModal() => setState(() => modalAbierto = null);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isLandscape = size.width > size.height;

    // 🔹 Altura de la portada según orientación
    final portadaHeight = isLandscape ? size.height * 0.6 : size.height * 0.4;

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
          'alignment': const Alignment(0, -0.5),
        },
      if (masajesPermitidos.isNotEmpty)
        {
          'titulo': 'Masajes previos a tu rutina',
          'tipo': 'masajes',
          'imagen': 'assets/images/masajes.jpg',
          'alignment': const Alignment(0, -0.5),
        },
      if (clasesPermitidas.isNotEmpty)
        {
          'titulo': 'Clases extra',
          'tipo': 'clases',
          'imagen': 'assets/images/clases.jpg',
          'alignment': const Alignment(0, -0.4),
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
                  height: portadaHeight,
                  fit: BoxFit.cover,
                  alignment: Alignment(0, -0.7), // ajustar inicio de la imagen
                ),
                Container(
                  width: double.infinity,
                  height: portadaHeight,
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

                    // 🔹 Ajuste ancho y alto según orientación
                    final cardWidth = isLandscape ? width * 0.7 : width * 0.9;
                    final cardHeight = isLandscape ? 180.0 : 140.0;

                    return AnimatedScale(
                      scale: 1,
                      duration: const Duration(milliseconds: 200),
                      child: GestureDetector(
                        onTapUp: (_) => abrirModal(tipo),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          width: cardWidth,
                          height: cardHeight,
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
