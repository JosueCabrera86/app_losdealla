import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:app_losdealla/data/material_base.dart';

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
  List<Map<String, dynamic>> get masajesFiltrados => masajesBase
      .where((m) => (m['categoria'] ?? 0) <= widget.nivelUsuario)
      .toList();

  void abrirMasaje(Map<String, dynamic> masaje) {
    int imagenIndex = 0;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Cerrar",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Material(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.7,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: masaje['tipo'] == 'pdf'
                        ? Colors.deepPurple[50]
                        : Colors.pink[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      if (masaje['tipo'] == 'pdf')
                        Center(
                          child: Image.asset(
                            'assets/imgsuscriptores/${masaje['pdf'][imagenIndex]}',
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      if (masaje['tipo'] == 'video')
                        YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: masaje['video'],
                            flags: const YoutubePlayerFlags(autoPlay: false),
                          ),
                        ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 28),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final paddingLateral = 8.0;

    return Column(
      children: [
        ElevatedButton(
          onPressed: widget.onClose,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
          ),
          child: const Text('Cerrar masajes'),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingLateral),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: masajesFiltrados.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 16 / 9, // Mantener proporción 16:9
            ),
            itemBuilder: (context, index) {
              final masaje = masajesFiltrados[index];
              final bool esPDF = masaje['tipo'] == 'pdf';
              final String? videoId = !esPDF ? masaje['video'] : null;
              final String? thumbnailUrl =
              videoId != null ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg' : null;

              return GestureDetector(
                onTap: () => abrirMasaje(masaje),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Fondo neutro para evitar bordes negros
                      Container(color: Colors.grey[300]),

                      // Imagen PDF o video
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

                      // Capa semi-transparente
                      Container(color: Colors.black.withOpacity(0.3)),

                      // Contenido centrado
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
                              masaje['title'],
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
