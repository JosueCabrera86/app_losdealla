import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MasajesScreen extends StatefulWidget {
  final List<dynamic> material;
  final int nivelUsuario;
  final VoidCallback onClose;

  const MasajesScreen({
    super.key,
    required this.material,
    required this.nivelUsuario,
    required this.onClose,
  });

  @override
  State<MasajesScreen> createState() => _MasajesScreenState();
}

class _MasajesScreenState extends State<MasajesScreen> {
  int? _imagenIndex;
  Map<String, dynamic>? _masajeSeleccionado;

  final List<Map<String, dynamic>> masajesBase = [
    {'categoria': 2, 'tipo': 'video', 'title': 'Masaje periférico', 'video': 'SJ20LZe3RxI'},
    {'categoria': 3, 'tipo': 'video', 'title': 'Masaje de reseteo facial', 'video': 'sG2qqWv9T9Y'},
    {'categoria': 4, 'tipo': 'video', 'title': 'Masaje de preparación facial', 'video': 'OUBvlbA8_Fk'},
    {'categoria': 9, 'tipo': 'video', 'title': 'Masaje con guasha', 'video': 'jPAeiOlCrv0'},
    {'categoria': 13, 'tipo': 'video', 'title': 'Masaje relajante', 'video': 'ke_h99NelDM'},
    {'categoria': 19, 'tipo': 'pdf', 'title': 'Masaje de acupresión', 'pdf': ['Acupresion-avanzados.png']},
  ];

  List<Map<String, dynamic>> get masajesFiltrados => masajesBase
      .where((m) => (m['categoria'] ?? 0) <= widget.nivelUsuario)
      .toList();

  void abrirMasaje(Map<String, dynamic> masaje) {
    setState(() {
      _masajeSeleccionado = masaje;
      _imagenIndex = 0;
    });
  }

  void cerrarMasaje() {
    setState(() {
      _masajeSeleccionado = null;
      _imagenIndex = null;
    });
  }

  void cambiarImagen(int dir) {
    if (_masajeSeleccionado?['pdf'] == null) return;
    final total = (_masajeSeleccionado!['pdf'] as List).length;
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
          child: const Text('Cerrar masajes'),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: masajesFiltrados.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final masaje = masajesFiltrados[index];
            return ElevatedButton(
              onPressed: () => abrirMasaje(masaje),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(masaje['title']),
                  Text(masaje['tipo'] == 'pdf' ? 'PDF' : 'Video'),
                ],
              ),
            );
          },
        ),
        if (_masajeSeleccionado != null)
          Center(
            child: Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 400,
                child: Stack(
                  children: [
                    if (_masajeSeleccionado!['tipo'] == 'pdf')
                      Center(
                        child: Image.asset(
                          'assets/images/${_masajeSeleccionado!['pdf'][_imagenIndex!]}',
                          fit: BoxFit.contain,
                        ),
                      ),
                    if (_masajeSeleccionado!['tipo'] == 'video')
                      YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: _masajeSeleccionado!['video'],
                          flags: const YoutubePlayerFlags(autoPlay: false),
                        ),
                        showVideoProgressIndicator: true,
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: cerrarMasaje,
                      ),
                    ),
                    if (_masajeSeleccionado!['tipo'] == 'pdf' &&
                        (_masajeSeleccionado!['pdf'] as List).length > 1)
                      Positioned(
                        left: 8,
                        top: 180,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_left, size: 32),
                          onPressed: () => cambiarImagen(-1),
                        ),
                      ),
                    if (_masajeSeleccionado!['tipo'] == 'pdf' &&
                        (_masajeSeleccionado!['pdf'] as List).length > 1)
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
