import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NivelIntermedio extends StatefulWidget {
  final List<dynamic> material;
  final int nivelUsuario;
  final VoidCallback onClose;

  const NivelIntermedio({
    super.key,
    required this.material,
    required this.nivelUsuario,
    required this.onClose,
  });

  @override
  State<NivelIntermedio> createState() => _NivelIntermedioState();
}

class _NivelIntermedioState extends State<NivelIntermedio> {
  int? _seleccionIndex;
  Map<String, dynamic>? _seleccionado;

  final List<Map<String, dynamic>> base = [
    {'categoria': 3, 'tipo': 'video', 'title': 'Posición Cerrada', 'video': 'u2OEmNMYTCw'},
    {'categoria': 3, 'tipo': 'video', 'title': 'Desplazamientos', 'video': 'K4bLW4_-w9Q'},
    {'categoria': 3, 'tipo': 'video', 'title': 'Sácala y peinate', 'video': 'gYRVZobHOeE'},
    {'categoria': 3, 'tipo': 'video', 'title': 'Rodeo', 'video': 'gYRVZobHOeE'},
    {'categoria': 3, 'tipo': 'video', 'title': 'Pasea y Pasea con sácala', 'video': 'gYRVZobHOeE'},
    {'categoria': 3, 'tipo': 'video', 'title': 'Dile que no', 'video': 'gYRVZobHOeE'},
  ];

  List<Map<String, dynamic>> get filtrado =>
      base.where((m) => (m['categoria'] ?? 0) <= widget.nivelUsuario).toList();

  void abrirRutina(Map<String, dynamic> rutina) {
    setState(() {
      _seleccionado = rutina;
      _seleccionIndex = 0;
    });
  }

  void cerrarRutina() {
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
          child: const Text('Cerrar Nivel Intermedio'),
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
                      Container(color: Colors.grey[300]),

                      if (esPDF)
                        Image.asset(
                          'assets/images/pdf_thumb.jpg',
                          fit: BoxFit.cover,
                        )
                      else
                        Image.network(
                          thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.error, color: Colors.red, size: 40),
                              ),
                            );
                          },
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

        if (_seleccionado != null)
          Center(
            child: Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 400,
                child: Stack(
                  children: [
                    if (_seleccionado!['tipo'] == 'pdf')
                      Center(
                        child: Image.asset(
                          'assets/images/${_seleccionado!['pdf'][_seleccionIndex!]}',
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    if (_seleccionado!['tipo'] == 'video')
                      YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: _seleccionado!['video'],
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
                    if (_seleccionado!['tipo'] == 'pdf' &&
                        (_seleccionado!['pdf'] as List).length > 1)
                      Positioned(
                        left: 8,
                        top: 180,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_left, size: 32),
                          onPressed: () => cambiarPDF(-1),
                        ),
                      ),
                    if (_seleccionado!['tipo'] == 'pdf' &&
                        (_seleccionado!['pdf'] as List).length > 1)
                      Positioned(
                        right: 8,
                        top: 180,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_right, size: 32),
                          onPressed: () => cambiarPDF(1),
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
