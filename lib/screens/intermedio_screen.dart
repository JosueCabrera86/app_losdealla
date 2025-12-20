import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // IMPORTANTE para SystemChrome
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

    // Forzar Horizontal al abrir
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHD: true,
      ),
    );

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Cerrar",
      barrierColor: Colors.black.withOpacity(0.85),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(
                      controller: _controller!,
                      showVideoProgressIndicator: true,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 26),
                    onPressed: () {
                      _controller?.pause();
                      _controller?.dispose();

                      // Volver a Vertical al cerrar
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ]);
                      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      _controller?.dispose();
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5), // Color de fondo solicitado
      child: SingleChildScrollView( // Se agrega para permitir scroll si la lista es larga
        child: Column(
          children: [
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: widget.onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar Nivel Intermedio'),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtrado.length,
              itemBuilder: (context, index) {
                final rutina = filtrado[index];
                final videoId = rutina['video'];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: GestureDetector(
                      onTap: () => abrirRutina(rutina),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/imgminis/miniyf/${rutina['portada']}',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.network(
                                'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(color: Colors.black.withOpacity(0.35)),
                            const Center(
                              child: Icon(
                                Icons.play_circle_fill,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}