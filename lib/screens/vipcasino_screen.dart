import 'package:flutter/material.dart';
import 'modales_casino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VipCasinoScreen extends StatefulWidget {
  const VipCasinoScreen({super.key});

  @override
  State<VipCasinoScreen> createState() => _VipCasinoScreenState();
}

class _VipCasinoScreenState extends State<VipCasinoScreen> {
  int nivelUsuario = 0;
  String? modalAbierto;
  String? error;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    fetchNivelUsuario();
  }

  Future<void> fetchNivelUsuario() async {
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

    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final secciones = [
      if (nivelUsuario >= 1)
        {
          'titulo': 'Nivel Principiante',
          'tipo': 'principiante',
          'imagen': 'assets/imgcasino/principiante1.jpeg',
          'alignment': Alignment(0, 1),
        },

      if (nivelUsuario >= 2)
        {
          'titulo': 'Nivel Básico',
          'tipo': 'basico',
          'imagen': 'assets/imgcasino/basico.jpeg',
          'alignment': Alignment(0,-0.2),
        },

      if (nivelUsuario >= 3)
        {
          'titulo': 'Nivel Intermedio',
          'tipo': 'intermedio',
          'imagen': 'assets/imgcasino/intermedio.jpeg',
          'alignment': Alignment(0, 0),
        },
      if (nivelUsuario >= 4)
        {
          'titulo': 'Nivel Avanzado',
          'tipo': 'avanzado',
          'imagen': 'assets/imgcasino/avanzado.jpeg',
          'alignment': Alignment(0, -0.2),
        },
    ];

    // 🔹 Altura de la portada según orientación
    final portadaHeight = isLandscape ? size.height * 0.6 : size.height * 0.4;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🌄 Portada principal
            Stack(
              children: [
                Image.asset(
                  'assets/images/casino.jpg',
                  width: double.infinity,
                  height: portadaHeight,
                  fit: BoxFit.cover,
                  alignment: Alignment(0, 0), // puedes cambiarlo a (0,0) o (-0.5,0) según quieras
                ),
                Container(
                  width: double.infinity,
                  height: portadaHeight,
                  color: Colors.black.withOpacity(0.5),
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
                        'Formación de Profesores de Casino',
                        style: TextStyle(
                          color: Colors.cyanAccent,
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
                '¡Hola! Este espacio está diseñado para acompañarte en tu proceso de formación en Casino (Salsa cubana) y fortalecer tu práctica.',
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

            // 🎴 Tarjetas por nivel
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

            // 🎬 Modales según nivel
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
