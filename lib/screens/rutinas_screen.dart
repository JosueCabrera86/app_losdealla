import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RutinasScreen extends StatefulWidget {
  final List<dynamic> material;
  final int nivelUsuario;
  final VoidCallback onClose;

  const RutinasScreen({
    super.key,
    required this.material,
    required this.nivelUsuario,
    required this.onClose,
  });

  @override
  State<RutinasScreen> createState() => _RutinasScreenState();
}

class _RutinasScreenState extends State<RutinasScreen> {
  int? _imagenIndex;
  Map<String, dynamic>? _rutinaSeleccionada;

  final List<Map<String, dynamic>> rutinasBase = [
    {'categoria': 5, 'tipo': 'pdf', 'title': '1. Frente y ojos', 'pdf': ['Frente-y-ojos-1.png']},
    {'categoria': 6, 'tipo': 'video', 'title': '1. Frente y ojos', 'video': 'xW4U1i4XxJg'},
    {'categoria': 7, 'tipo': 'pdf', 'title': '2. Una rutina para ojos', 'pdf': ['Ojos-1.png']},
    {'categoria': 8, 'tipo': 'video', 'title': '2. Una rutina para ojos', 'video': '6tkfc-pobr0'},
    {'categoria': 9, 'tipo': 'pdf', 'title': '3. Línea facial y cuello', 'pdf': ['Linea-Facial-y-Cuello-1.png']},
    {'categoria': 10, 'tipo': 'video', 'title': '3. Línea facial y cuello', 'video': 'Q6pmDrXMROs'},
    {'categoria': 14, 'tipo': 'pdf', 'title': '4. Nariz, labios y nasolabiales', 'pdf': ['Nariz-Labios-y-Nasolabiales-1.png','Nariz-Labios-y-Nasolabiales-2.png','Nariz-Labios-y-Nasolabiales-3.png','Frente-y-ojos-4.png']},
    {'categoria': 15, 'tipo': 'video', 'title': '4. Nariz, labios y nasolabiales', 'video': 'v0nMSc7bDEI'},
    {'categoria': 17, 'tipo': 'pdf', 'title': '5. Pómulos y sonrisa', 'pdf': ['Pomulos-y-Sonrisa-1.png','Pomulos-y-Sonrisa-2.png','Pomulos-y-Sonrisa-3.png','Frente-y-ojos-4.png']},
    {'categoria': 18, 'tipo': 'video', 'title': '5. Pómulos y sonrisa', 'video': 'uPnft5T1_Ps'},
    {'categoria': 20, 'tipo': 'video', 'title': '6. Acupresión avanzada', 'video': 'BoCZ0nkv58M'},
  ];

  List<Map<String, dynamic>> get rutinasFiltradas => rutinasBase
      .where((r) => (r['categoria'] ?? 0) <= widget.nivelUsuario)
      .toList();

  void abrirRutina(Map<String, dynamic> rutina) {
    setState(() {
      _rutinaSeleccionada = rutina;
      _imagenIndex = 0;
    });
  }

  void cerrarRutina() {
    setState(() {
      _rutinaSeleccionada = null;
      _imagenIndex = null;
    });
  }

  void cambiarImagen(int dir) {
    if (_rutinaSeleccionada?['pdf'] == null) return;
    final total = (_rutinaSeleccionada!['pdf'] as List).length;
    setState(() {
      _imagenIndex = (_imagenIndex! + dir + total) % total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: widget.onClose,
          child: const Text('Cerrar rutinas'),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rutinasFiltradas.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final rutina = rutinasFiltradas[index];
            return ElevatedButton(
              onPressed: () => abrirRutina(rutina),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(rutina['title']),
                  Text(rutina['tipo'] == 'pdf' ? 'PDF' : 'Video'),
                ],
              ),
            );
          },
        ),
        if (_rutinaSeleccionada != null)
          Center(
            child: Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 400,
                child: Stack(
                  children: [
                    if (_rutinaSeleccionada!['tipo'] == 'pdf')
                      Center(
                        child: Image.asset(
                          'assets/images/${_rutinaSeleccionada!['pdf'][_imagenIndex!]}',
                          fit: BoxFit.contain,
                        ),
                      ),
                    if (_rutinaSeleccionada!['tipo'] == 'video')
                      YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: _rutinaSeleccionada!['video'],
                          flags: const YoutubePlayerFlags(autoPlay: false),
                        ),
                        showVideoProgressIndicator: true,
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: cerrarRutina,
                      ),
                    ),
                    if (_rutinaSeleccionada!['tipo'] == 'pdf' &&
                        (_rutinaSeleccionada!['pdf'] as List).length > 1)
                      Positioned(
                        left: 8,
                        top: 180,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_left, size: 32),
                          onPressed: () => cambiarImagen(-1),
                        ),
                      ),
                    if (_rutinaSeleccionada!['tipo'] == 'pdf' &&
                        (_rutinaSeleccionada!['pdf'] as List).length > 1)
                      Positioned(
                        right: 8,
                        top: 180,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_right, size: 32),
                          onPressed: () => cambiarImagen(1),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
