import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NivelAvanzado extends StatefulWidget {
  final List<dynamic> material;
  final int nivelUsuario;
  final VoidCallback onClose;

  const NivelAvanzado({
    super.key,
    required this.material,
    required this.nivelUsuario,
    required this.onClose,
  });

  @override
  State<NivelAvanzado> createState() => _NivelAvanzadoState();
}

class _NivelAvanzadoState extends State<NivelAvanzado> {
  YoutubePlayerController? _controller;

  final List<Map<String, dynamic>> base = [
    {
      'categoria': 4,
      'tipo': "video",
      'title': "Cohiba",
      'video': "OQBZq6j-hhY",
      'portada': "25_avanzado_cohiba.png",
    },
    {
      'categoria': 4,
      'tipo': "video",
      'title': "Especula",
      'video': "xOvcJJ1nLXw",
      'portada': "26_avanzado_especula.png",
    },
    {
      'categoria': 4,
      'tipo': "video",
      'title': "Vuela, vuela",
      'video': "3gqL4xnD0BM",
      'portada': "27_avanzado_vuelavuela.png",
    },
    {
      'categoria': 4,
      'tipo': "video",
      'title': "Sombreros",
      'video': "nEEnsPDZC70",
      'portada': "28_avanzado_sombreros.png",
    },
    {
      'categoria': 4,
      'tipo': "video",
      'title': "Setenta complicado y Setenta y nueve",
      'video': "p8UPTIRJRsk",
      'portada': "29_avanzado_setentacomplicado.png",
    },
    {
      'categoria': 4,
      'tipo': "video",
      'title': "Bayamo´s",
      'video': "LGb75_mzp1w",
      'portada': "30_avanzado_bayamos.png",
    },
    {
      'categoria': 4,
      'tipo': "video",
      'title': "Matanzas",
      'video': "CEo12dJpjl8",
      'portada': "31_avanzado_matanzas.png",
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
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 26,
                    ),
                    onPressed: () {
                      _controller?.pause();
                      _controller?.dispose();


                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ]);
                      SystemChrome.setEnabledSystemUIMode(
                        SystemUiMode.edgeToEdge,
                      );

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
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
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
          color: const Color(0xFFF5F5F5),
      child: Column(
      children: [
        ElevatedButton(
          onPressed: widget.onClose,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
          ),
          child: const Text('Cerrar Nivel Avanzado'),
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
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal:8),
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
