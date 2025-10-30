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
    int imagenIndex = 0; // Estado local al modal

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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // PDF
                      if (masaje['tipo'] == 'pdf')
                        Center(
                          child: Image.asset(
                            'assets/imgsuscriptores/${masaje['pdf'][imagenIndex]}',
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      // Video
                      if (masaje['tipo'] == 'video')
                        YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: masaje['video'],
                            flags: const YoutubePlayerFlags(autoPlay: false),
                          ),
                          showVideoProgressIndicator: true,
                        ),

                      // Botón cerrar
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.close, size: 28),
                          color: Colors.black87,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),

                      // Navegación PDF
                      if (masaje['tipo'] == 'pdf' &&
                          (masaje['pdf'] as List).length > 1)
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.chevron_left, size: 36),
                              color: Colors.black87,
                              onPressed: () {
                                setModalState(() {
                                  imagenIndex = (imagenIndex - 1 +
                                      (masaje['pdf'] as List).length) %
                                      (masaje['pdf'] as List).length;
                                });
                              },
                            ),
                          ),
                        ),
                      if (masaje['tipo'] == 'pdf' &&
                          (masaje['pdf'] as List).length > 1)
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.chevron_right, size: 36),
                              color: Colors.black87,
                              onPressed: () {
                                setModalState(() {
                                  imagenIndex =
                                      (imagenIndex + 1) % (masaje['pdf'] as List).length;
                                });
                              },
                            ),
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
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim1, curve: Curves.easeOut),
          child: ScaleTransition(
            scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        ElevatedButton(
          onPressed: widget.onClose,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white, // Texto blanco
          ),
          child: const Text('Cerrar masajes'),
        ),
        const SizedBox(height: 12),
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
            return GestureDetector(
              onTap: () => abrirMasaje(masaje),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(
                      masaje['tipo'] == 'pdf'
                          ? 'assets/images/pdf_thumb.jpg'
                          : 'assets/images/video_thumb.jpg',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3),
                      BlendMode.darken,
                    ),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      masaje['title'],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      masaje['tipo'] == 'pdf' ? 'PDF' : 'Video',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
