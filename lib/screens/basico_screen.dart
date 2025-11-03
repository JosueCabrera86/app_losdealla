import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NivelBasico extends StatefulWidget {
  final List<dynamic> material;
  final int nivelUsuario;
  final VoidCallback onClose;

  const NivelBasico({
    super.key,
    required this.material,
    required this.nivelUsuario,
    required this.onClose,
  });

  @override
  State<NivelBasico> createState() => _NivelBasicoState();
}

class _NivelBasicoState extends State<NivelBasico> {
  int? _seleccionIndex;
  Map<String, dynamic>? _seleccionado;
  YoutubePlayerController? _controller;

  final List<Map<String, dynamic>> base = [
    {'categoria': 2, 'tipo': 'video', 'title': 'Posición Cerrada', 'video': 'u2OEmNMYTCw'},
    {'categoria': 2, 'tipo': 'video', 'title': 'Desplazamientos', 'video': 'K4bLW4_-w9Q'},
    {'categoria': 2, 'tipo': 'video', 'title': 'Sácala y peinate', 'video': 'gYRVZobHOeE'},
    {'categoria': 2, 'tipo': 'video', 'title': 'Rodeo', 'video': 'gYRVZobHOeE'},
    {'categoria': 2, 'tipo': 'video', 'title': 'Pasea y Pasea con sácala', 'video': 'gYRVZobHOeE'},
    {'categoria': 2, 'tipo': 'video', 'title': 'Dile que no', 'video': 'gYRVZobHOeE'},
  ];

  List<Map<String, dynamic>> get filtrado =>
      base.where((m) => (m['categoria'] ?? 0) <= widget.nivelUsuario).toList();

  void abrirRutina(Map<String, dynamic> rutina) {
    setState(() {
      _seleccionado = rutina;
      _seleccionIndex = 0;
    });

    if (rutina['tipo'] == 'video') {
      final videoId = rutina['video'];
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.95),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, anim1, anim2) {
          return YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.amber,
            ),
            builder: (context, player) => Scaffold(
              backgroundColor: Colors.black,
              body: SafeArea(
                child: Stack(
                  children: [
                    Center(child: player),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: () {
                          _controller?.pause();
                          Navigator.pop(context);
                          cerrarRutina();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void cerrarRutina() {
    _controller?.dispose();
    _controller = null;
    setState(() {
      _seleccionado = null;
      _seleccionIndex = null;
    });
  }

  void cambiarPDF(int dir) {
    if (_seleccionado?['pdf'] == null) return;
    final total = (_seleccionado!['pdf'] as List).length;
    setState(() {
      _seleccionIndex = (_seleccionIndex! + dir + total) % total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final paddingLateral = 8.0;

    return Column(
      children: [
        ElevatedButton(
          onPressed: widget.onClose,
          child: const Text('Cerrar Nivel Básico'),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingLateral),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtrado.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 16 / 9,
            ),
            itemBuilder: (context, index) {
              final rutina = filtrado[index];
              final bool esPDF = rutina['tipo'] == 'pdf';
              final String? videoId = !esPDF ? rutina['video'] : null;
              final String? thumbnailUrl = videoId != null
                  ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg'
                  : null;

              return GestureDetector(
                onTap: () => abrirRutina(rutina),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (esPDF)
                        Image.asset(
                          'assets/images/pdf_thumb.jpg',
                          fit: BoxFit.cover,
                        )
                      else
                        Image.network(
                          thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.error, color: Colors.red, size: 40),
                            ),
                          ),
                        ),
                      Container(color: Colors.black.withOpacity(0.3)),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!esPDF)
                              const Icon(
                                Icons.play_circle_fill,
                                color: Colors.white,
                                size: 50,
                              ),
                            const SizedBox(height: 6),
                            Text(
                              rutina['title'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 4,
                                    color: Colors.black54,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                            if (esPDF) const SizedBox(height: 4),
                            if (esPDF)
                              const Text(
                                'PDF',
                                style: TextStyle(color: Colors.white70),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
