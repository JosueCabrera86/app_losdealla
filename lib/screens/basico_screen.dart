import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

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
  YoutubePlayerController? _controller;

  final List<Map<String, dynamic>> base = [
    {
      'categoria': 2,
      'tipo': "video",
      'title': "Posición Cerrada",
      'video': "ryxL7IXTyQI",
      'portada': "4_basico_posicioncerrada.png",
    },
    {
      'categoria': 2,
      'tipo': "video",
      'title': "Sácala y péinate",
      'video': "1fxSJXWLSwU",
      'portada': "5_basico_sacalaypeinate.png",
    },
    {
      'categoria': 2,
      'tipo': "video",
      'title': "Paseos",
      'video': "o-Jydx7ruZo",
      'portada': "6_basico_paseos.png",
    },
    {
      'categoria': 2,
      'tipo': "video",
      'title': "Rodeo",
      'video': "auGzY95if_8",
      'portada': "7_basico_rodeo.png",
    },
    {
      'categoria': 2,
      'tipo': "video",
      'title': "Dile que no",
      'video': "BHG8MV2ieEE",
      'portada': "8_basico_dilequeno.png",
    },
    {
      'categoria': 2,
      'tipo': "video",
      'title': "Dile que sí",
      'video': "W7jiwxY9tVM",
      'portada': "9_basico_dilequesi.png",
    },
    {
      'categoria': 2,
      'tipo': "video",
      'title': "Prima",
      'video': "lWsYka89E0o",
      'portada': "10_basico_prima.png",
    },
    {
      'categoria': 2,
      'tipo': "video",
      'title': "Enchufas-enchuflas",
      'video': "QLD0N0fVS14",
      'portada': "11_basico_enchuflas.png",
    },
    {
      'categoria': 2,
      'tipo': "video",
      'title': "Sencillas",
      'video': "wZbLUIofTMo",
      'portada': "12_basico_sencillas.png",
    },
    {
      'categoria': 2,
      'tipo': "video",
      'title': "Dedos",
      'video': "SeXkZneflwI",
      'portada': "13_basico_dedos.png",
    },
    {
      'categoria': 2,
      'tipo': "video",
      'title': "Vuelta al hombro",
      'video': "L1Jb4Z3CSKQ",
      'portada': "14_basico_vueltaalhombro.png",
    },
    {
      'categoria': 2,
      'tipo': "video",
      'title': "Vacílala",
      'video': "f1g53q4f0Jg",
      'portada': "15_basico_vacilala.png",
    },
  ];

  List<Map<String, dynamic>> get filtrado =>
      base.where((m) => (m['categoria'] ?? 0) <= widget.nivelUsuario).toList();

  void abrirRutina(Map<String, dynamic> rutina) {
    if (rutina['tipo'] != 'video') return;
    final videoId = rutina['video'];

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
                      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
      color: const Color(0xFFF5F5F5), // Color de fondo igual al avanzado
      child: Column(
        children: [
          ElevatedButton(
            onPressed: widget.onClose,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Nivel Básico'),
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
                          // 🎞️ Portada
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
    );
  }
}