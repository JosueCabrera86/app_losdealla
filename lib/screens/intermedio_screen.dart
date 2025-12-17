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
  YoutubePlayerController? _controller;

  final List<Map<String, dynamic>> base = [
    {
      'categoria': 3,
      'tipo': "video",
      'title': "Kentucky",
      'video': "YNDkKzYqyOE",
      'portada': "16_intermedio_kentucky.png",
    },
    {
      'categoria': 3,
      'tipo': "video",
      'title': "Amistad Cuba Jamaica",
      'video': "MrAWlOLoG6Y",
      'portada': "17_intermedio_amistadcubajamaica.png",
    },
    {
      'categoria': 3,
      'tipo': "video",
      'title': "Setenta (70)",
      'video': "ZS7u4lWlrvo",
      'portada': "18_intermedio_setenta.png",
    },
    {
      'categoria': 3,
      'tipo': "video",
      'title': "Setentas (70´s)",
      'video': "Ly1M2z93QLc",
      'portada': "19_intermedio_setentas.png",
    },
    {
      'categoria': 3,
      'tipo': "video",
      'title': "Sombrero",
      'video': "WgOqgojrGYE",
      'portada': "20_intermedio_sombrero.png",
    },
    {
      'categoria': 3,
      'tipo': "video",
      'title': "Caracol",
      'video': "IFzsSENZm04",
      'portada': "21_intermedio_caracol.png",
    },
    {
      'categoria': 3,
      'tipo': "video",
      'title': "Copa",
      'video': "n_FYzQ987yA",
      'portada': "22_intermedio_copa.png",
    },
    {
      'categoria': 3,
      'tipo': "video",
      'title': "Azúcar",
      'video': "iNevd-mHIyA",
      'portada': "23_intermedio_azucar.png",
    },
    {
      'categoria': 3,
      'tipo': "video",
      'title': "Bayamo por arriba",
      'video': "1j4-yoml2E8",
      'portada': "24_intermedio_bayamoporarriba.png",
    },
  ];

  List<Map<String, dynamic>> get filtrado =>
      base.where((m) => (m['categoria'] ?? 0) <= widget.nivelUsuario).toList();

  void abrirRutina(Map<String, dynamic> rutina) {
    if (rutina['tipo'] != 'video') return;

    final videoId = rutina['video'];
    _controller?.pause();
    _controller?.dispose();
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
    );

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Cerrar",
      barrierColor: Colors.black.withOpacity(0.85),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return OrientationBuilder(
          builder: (context, orientation) {
            final bool isLandscape = orientation == Orientation.landscape;

            if (isLandscape) {
              // Vista de Video en Horizontal: Pantalla Completa
              return Scaffold(
                backgroundColor: Colors.black,
                // Se elimina SafeArea para intentar una experiencia de pantalla más completa,
                // aunque en dispositivos modernos se recomienda dejarla.
                body: Stack(
                  children: [
                    Positioned.fill(
                      child: YoutubePlayerBuilder(
                        player: YoutubePlayer(
                          controller: _controller!,
                          showVideoProgressIndicator: true,
                        ),
                        builder: (context, player) => Center(child: player),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 30),
                        onPressed: () {
                          _controller?.pause();
                          Navigator.of(context).pop();
                          _controller?.dispose();
                          _controller = null;
                        },
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Vista de Video en Vertical: Modal
              final size = MediaQuery.of(context).size;
              final modalWidth = size.width * 0.9;
              final modalHeight = size.height * 0.62;
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Container(
                    width: modalWidth,
                    height: modalHeight,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: YoutubePlayer(
                              controller: _controller!,
                              showVideoProgressIndicator: true,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white, size: 28),
                            onPressed: () {
                              _controller?.pause();
                              Navigator.of(context).pop();
                              _controller?.dispose();
                              _controller = null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        final size = MediaQuery.of(context).size;
        final bool isLandscape = orientation == Orientation.landscape;

        // CAMBIO CLAVE PARA ADAPTACIÓN HORIZONTAL:
        // Usa 1 columna en modo Vertical (Portrait) y 3 en Horizontal (Landscape)
        final crossAxisCount = isLandscape ? 3 : 1;
        final childAspectRatio = 16 / 9; // El aspecto 16:9 es el correcto para video thumbnails
        final paddingLateral = size.width * 0.02;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingLateral, vertical: 8),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: widget.onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Cerrar Nivel Intermedio'),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtrado.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: childAspectRatio,
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
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(color: Colors.grey[300]),
                            if (rutina['portada'] != null)
                              Image.asset(
                                'assets/imgminis/miniyf/${rutina['portada']}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                thumbnailUrl != null
                                    ? Image.network(thumbnailUrl, fit: BoxFit.cover)
                                    : Container(color: Colors.grey[300]),
                              )
                            else if (esPDF)
                              Image.asset('assets/images/pdf_thumb.jpg', fit: BoxFit.cover)
                            else if (thumbnailUrl != null)
                                Image.network(thumbnailUrl, fit: BoxFit.cover)
                              else
                                Container(color: Colors.grey[300]),
                            Container(color: Colors.black.withOpacity(0.32)),
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (!esPDF)
                                    const Icon(Icons.play_circle_fill,
                                        color: Colors.white, size: 52),
                                  if (esPDF)
                                    const Icon(Icons.picture_as_pdf,
                                        color: Colors.white, size: 40),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}