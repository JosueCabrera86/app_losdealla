import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:app_losdealla/data/material_base.dart';

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
  List<Map<String, dynamic>> get clasesFiltradas => clasesBase
      .where((c) => (c['categoria'] ?? 0) <= widget.nivelUsuario)
      .toList();

  void abrirClase(Map<String, dynamic> clase) {
    int imagenIndex = 0; // Estado local dentro del modal

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
                    color: clase['tipo'] == 'pdf'
                        ? Colors.blue[50]
                        : Colors.orange[50],
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
                      // Mostrar PDF o video
                      if (clase['tipo'] == 'pdf')
                        Center(
                          child: Image.asset(
                            'assets/imgsuscriptores/${clase['pdf'][imagenIndex]}',
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      if (clase['tipo'] == 'video')
                        YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: clase['video'],
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
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),

                      // Navegación PDF
                      if (clase['tipo'] == 'pdf' &&
                          (clase['pdf'] as List).length > 1)
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.chevron_left, size: 36),
                              onPressed: () {
                                setModalState(() {
                                  imagenIndex = (imagenIndex - 1 +
                                      (clase['pdf'] as List).length) %
                                      (clase['pdf'] as List).length;
                                });
                              },
                            ),
                          ),
                        ),
                      if (clase['tipo'] == 'pdf' &&
                          (clase['pdf'] as List).length > 1)
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.chevron_right, size: 36),
                              onPressed: () {
                                setModalState(() {
                                  imagenIndex =
                                      (imagenIndex + 1) % (clase['pdf'] as List).length;
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
            backgroundColor: Colors.orangeAccent,
          ),
          child: const Text('Cerrar clases extra'),
        ),
        const SizedBox(height: 12),
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
            return GestureDetector(
              onTap: () => abrirClase(clase),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(
                      clase['tipo'] == 'pdf'
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
                      clase['title'],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      clase['tipo'] == 'pdf' ? 'PDF' : 'Video',
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
