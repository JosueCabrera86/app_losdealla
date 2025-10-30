import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ClasesExtraScreen extends StatefulWidget {
  final List<dynamic> material;
  final int nivelUsuario;
  final VoidCallback onClose;

  const ClasesExtraScreen({
    super.key,
    required this.material,
    required this.nivelUsuario,
    required this.onClose,
  });

  @override
  State<ClasesExtraScreen> createState() => _ClasesExtraScreenState();
}

class _ClasesExtraScreenState extends State<ClasesExtraScreen> {
  int? _imagenIndex;
  Map<String, dynamic>? _claseSeleccionada;

  final List<Map<String, dynamic>> clasesBase = [
    {'categoria': 1, 'tipo': 'pdf', 'title': 'Clase introductoria', 'pdf': ['portadainfo.png','info9.png','info10.png','info11.png','info12.png','frente_y_ojos-4.png']},
    {'categoria': 1, 'tipo': 'video', 'title': 'Clase introductoria', 'video': 'u2OEmNMYTCw'},
    {'categoria': 4, 'tipo': 'video', 'title': 'Clase 1', 'video': 'K4bLW4_-w9Q'},
    {'categoria': 10, 'tipo': 'video', 'title': 'Clase 2', 'video': 'gYRVZobHOeE'},
    {'categoria': 16, 'tipo': 'video', 'title': 'Clase 3', 'video': 'iBkVM0zyLRc'},
    {'categoria': 21, 'tipo': 'video', 'title': 'Clase especial de Kinesiotape', 'video': 'iozMsfyRchA'},
  ];

  List<Map<String, dynamic>> get clasesFiltradas => clasesBase
      .where((c) => (c['categoria'] ?? 0) <= widget.nivelUsuario)
      .toList();

  void abrirClase(Map<String, dynamic> clase) {
    setState(() {
      _claseSeleccionada = clase;
      _imagenIndex = 0;
    });
  }

  void cerrarClase() {
    setState(() {
      _claseSeleccionada = null;
      _imagenIndex = null;
    });
  }

  void cambiarImagen(int dir) {
    if (_claseSeleccionada?['pdf'] == null) return;
    final total = (_claseSeleccionada!['pdf'] as List).length;
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
          child: const Text('Cerrar clases extra'),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: clasesFiltradas.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final clase = clasesFiltradas[index];
            return ElevatedButton(
              onPressed: () => abrirClase(clase),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(clase['title']),
                  Text(clase['tipo'] == 'pdf' ? 'PDF' : 'Video'),
                ],
              ),
            );
          },
        ),
        if (_claseSeleccionada != null)
          Center(
            child: Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 400,
                child: Stack(
                  children: [
                    if (_claseSeleccionada!['tipo'] == 'pdf')
                      Center(
                        child: Image.asset(
                          'assets/images/${_claseSeleccionada!['pdf'][_imagenIndex!]}',
                          fit: BoxFit.contain,
                        ),
                      ),
                    if (_claseSeleccionada!['tipo'] == 'video')
                      YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: _claseSeleccionada!['video'],
                          flags: const YoutubePlayerFlags(autoPlay: false),
                        ),
                        showVideoProgressIndicator: true,
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: cerrarClase,
                      ),
                    ),
                    if (_claseSeleccionada!['tipo'] == 'pdf' &&
                        (_claseSeleccionada!['pdf'] as List).length > 1)
                      Positioned(
                        left: 8,
                        top: 180,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_left, size: 32),
                          onPressed: () => cambiarImagen(-1),
                        ),
                      ),
                    if (_claseSeleccionada!['tipo'] == 'pdf' &&
                        (_claseSeleccionada!['pdf'] as List).length > 1)
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
