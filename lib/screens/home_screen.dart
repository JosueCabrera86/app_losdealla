import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool _showContent = false;
  final Color colorPurple = const Color(0xFF512DA8);
  final Color colorFondo = const Color(0xFFF3E5F5);

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _showContent = true);
    });
  }

  Future<void> _cerrarSesionGlobal() async {
    await Supabase.instance.client.auth.signOut();
    await storage.deleteAll();
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión cerrada correctamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  Future<void> manejarAcceso(String tipoBoton) async {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    if (session != null) {
      String? disciplinaGuardada = await storage.read(key: 'user_disciplina');
      String disc = disciplinaGuardada?.toLowerCase() ?? '';

      if (disc.contains(tipoBoton)) {

        if (tipoBoton == 'casino') {
          Navigator.pushNamed(context, '/vipcasino');
        } else if (tipoBoton == 'yoga') {
          Navigator.pushNamed(context, '/suscriptoresyf');
        }
        return;
      } else {

        _mostrarAvisoCambio(tipoBoton);
        return;
      }
    }


    _irAlLogin(tipoBoton);
  }


  void _mostrarAvisoCambio(String nuevaDisciplina) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Sesión activa'),
        content: Text(
          'Ya tienes una sesión iniciada en otra disciplina.\n\n¿Deseas cerrar esa sesión para entrar a ${nuevaDisciplina == 'casino' ? 'Casino' : 'Yoga Facial'}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorPurple,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              await storage.deleteAll();
              if (mounted) {
                Navigator.pop(context); // Cierra el diálogo
                _irAlLogin(nuevaDisciplina);
              }
            },
            child: const Text('Sí, cambiar'),
          ),
        ],
      ),
    );
  }

  void _irAlLogin(String tipoBoton) {
    if (tipoBoton == 'casino') {
      Navigator.pushNamed(context, '/loginCasino');
    } else {
      Navigator.pushNamed(context, '/loginYoga');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    final double maxContentWidth = 600;
    final double imageSize = isLandscape
        ? (size.width * 0.2).clamp(100.0, 180.0)
        : (size.width * 0.45).clamp(120.0, 200.0);

    return Scaffold(
      backgroundColor: colorFondo,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: isLandscape ? 70 : 90,
        centerTitle: true,
        title: const Text(
          'Material Adicional',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        backgroundColor: const Color(0xFF512DA8),
        elevation: 0,

        actions: [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            elevation: 4,
            icon: const Icon(Icons.more_vert, color: Color(0xFFF3E5F5) ),
            onSelected: (value) {
              if (value == 'logout') {
                _cerrarSesionGlobal();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: colorPurple),
                    SizedBox(width: 10),
                    Text('Cerrar Sesión',
                    style: TextStyle(
                      color: colorPurple,
                    )
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¡Nos da mucho gusto que estés aquí!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (size.width * 0.05).clamp(18.0, 24.0),
                    fontWeight: FontWeight.bold,
                    color: colorPurple,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Te damos la bienvenida a este espacio creado para complementar tu práctica.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: (size.width * 0.04).clamp(14.0, 18.0),
                    color: colorPurple.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 40),
                isLandscape
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildOptionsList(context, imageSize),
                )
                    : Column(
                  children: _buildOptionsList(context, imageSize),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildOptionsList(BuildContext context, double imageSize) {
    return [
      _buildOption(
        context,
        image: 'assets/images/yoga_facial.jpg',
        label: 'Yoga Facial',
        width: imageSize,
        tipo: 'yoga',
      ),
      const SizedBox(width: 20, height: 30),
      _buildOption(
        context,
        image: 'assets/images/casino.jpg',
        label: 'Casino\n(Salsa Cubana)',
        width: imageSize,
        tipo: 'casino',
      ),
    ];
  }

  Widget _buildOption(
      BuildContext context, {
        required String image,
        required String label,
        required double width,
        required String tipo,
      }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedOpacity(
          opacity: _showContent ? 1 : 0,
          duration: const Duration(milliseconds: 800),
          child: AnimatedScale(
            scale: _showContent ? 1 : 0.9,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: InkWell(
                onTap: () => manejarAcceso(tipo),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    image,
                    width: width,
                    height: width,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: width,
                      height: width,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: (width * 0.12).clamp(14.0, 18.0),
            color: colorPurple,
          ),
        ),
      ],
    );
  }
}