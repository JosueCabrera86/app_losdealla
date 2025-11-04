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
    int imagenIndex = 0;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Cerrar",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return OrientationBuilder(
          builder: (context, orientation) {
            final isHorizontal = orientation == Orientation.landscape;
            final width = isHorizontal
                ? MediaQuery.of(context).size.width * 0.95
                : MediaQuery.of(context).size.width * 0.9;
            final height = isHorizontal
                ? MediaQuery.of(context).size.height * 0.9
                : MediaQuery.of(context).size.height * 0.7;

            return Material(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: StatefulBuilder(
                  builder: (context, setModalState) {
                    return Container(
                      width: width,
                      height: height,
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
                            Center(
                              child: YoutubePlayer(
                                controller: YoutubePlayerController(
                                  initialVideoId: clase['video'],
                                  flags: const YoutubePlayerFlags(
                                    autoPlay: false,
                                  ),
                                ),
                                showVideoProgressIndicator: true,
                              ),
                            ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.close, size: 28),
                              color: Colors.black87,
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          if (clase['tipo'] == 'pdf' &&
                              (clase['pdf'] as List).length > 1)
                            ...[
                              Positioned(
                                left: 0,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.chevron_left,
                                        size: 36),
                                    color: Colors.black87,
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
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: IconButton(
                                    icon: const Icon(Icons.chevron_right,
                                        size: 36),
                                    color: Colors.black87,
                                    onPressed: () {
                                      setModalState(() {
                                        imagenIndex = (imagenIndex + 1) %
                                            (clase['pdf'] as List).length;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
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
    final paddingLateral = 8.0;

    return Column(
      children: [
        ElevatedButton(
          onPressed: widget.onClose,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            foregroundColor: Colors.white,
          ),
          child: const Text('Cerrar clases extra'),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingLateral),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: clasesFiltradas.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 16 / 9,
            ),
            itemBuilder: (context, index) {
              final clase = clasesFiltradas[index];
              final bool esPDF = clase['tipo'] == 'pdf';
              final String? videoId = !esPDF ? clase['video'] : null;
              final String? thumbnailUrl = clase['portada'] != null
                  ? 'assets/imgminis/miniyf/${clase['portada']}'
                  : (videoId != null
                  ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg'
                  : null);

              return GestureDetector(
                onTap: () => abrirClase(clase),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: Colors.grey[300]),

                      // imagen o miniatura personalizada
                      if (thumbnailUrl != null)
                        thumbnailUrl.startsWith('assets')
                            ? Image.asset(thumbnailUrl, fit: BoxFit.cover)
                            : Image.network(
                          thumbnailUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.error,
                                    color: Colors.red, size: 40),
                              ),
                            );
                          },
                        ),

                      Container(color: Colors.black.withOpacity(0.3)),

                      // ==== títulos ocultos, íconos activos ====
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
                            // const SizedBox(height: 6),
                            // Text(
                            //   clase['title'],
                            //   textAlign: TextAlign.center,
                            //   style: const TextStyle(
                            //     color: Colors.white,
                            //     fontWeight: FontWeight.bold,
                            //     shadows: [
                            //       Shadow(
                            //         blurRadius: 4,
                            //         color: Colors.black54,
                            //         offset: Offset(1, 1),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // if (esPDF) const SizedBox(height: 4),
                            // if (esPDF)
                            //   const Text(
                            //     'PDF',
                            //     style: TextStyle(color: Colors.white70),
                            //   ),
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
