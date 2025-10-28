import 'package:flutter/material.dart';
import 'modales_yoga.dart';

class SuscriptoresYFScreen extends StatefulWidget {
  final int nivelUsuario;
  final List<Map<String, dynamic>> materialRutinas;
  final List<Map<String, dynamic>> materialMasajes;
  final List<Map<String, dynamic>> materialClases;

  const SuscriptoresYFScreen({
    super.key,
    this.nivelUsuario = 20,
    this.materialRutinas = const [],
    this.materialMasajes = const [],
    this.materialClases = const [],
  });

  @override
  State<SuscriptoresYFScreen> createState() => _SuscriptoresYFScreenState();
}

class _SuscriptoresYFScreenState extends State<SuscriptoresYFScreen> {
  String? modalAbierto; // 'rutinas', 'masajes', 'clases' o null

  void abrirModal(String tipo) {
    setState(() => modalAbierto = tipo);
  }

  void cerrarModal() {
    setState(() => modalAbierto = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero / Portada
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

            // Solo mostrar botones si no hay modal abierto
            if (modalAbierto == null)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => abrirModal('rutinas'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: modalAbierto == 'rutinas'
                          ? Colors.deepPurpleAccent
                          : Colors.deepPurple[100],
                    ),
                    child: const Text('Rutinas de Yoga Facial'),
                  ),
                  ElevatedButton(
                    onPressed: () => abrirModal('masajes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: modalAbierto == 'masajes'
                          ? Colors.deepPurpleAccent
                          : Colors.deepPurple[100],
                    ),
                    child: const Text('Masajes previos a tu rutina'),
                  ),
                  ElevatedButton(
                    onPressed: () => abrirModal('clases'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: modalAbierto == 'clases'
                          ? Colors.deepPurpleAccent
                          : Colors.deepPurple[100],
                    ),
                    child: const Text('Clases extra'),
                  ),
                ],
              ),

            const SizedBox(height: 16),

            // Secciones tipo modal
            if (modalAbierto == 'rutinas')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RutinasScreen(
                  material: widget.materialRutinas,
                  nivelUsuario: widget.nivelUsuario,
                  onClose: cerrarModal,
                ),
              ),
            if (modalAbierto == 'masajes')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MasajesScreen(
                  material: widget.materialMasajes,
                  nivelUsuario: widget.nivelUsuario,
                  onClose: cerrarModal,
                ),
              ),
            if (modalAbierto == 'clases')
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClasesExtraScreen(
                  material: widget.materialClases,
                  nivelUsuario: widget.nivelUsuario,
                  onClose: cerrarModal,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
