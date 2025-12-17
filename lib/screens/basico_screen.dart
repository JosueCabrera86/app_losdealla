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
    if (rutina['tipo'] == 'video') {
      final videoId = rutina['video'];
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
      );

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Cerrar",
        barrierColor: Colors.black.withOpacity(0.7),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, anim1, anim2) {
          return OrientationBuilder(
            builder: (context, orientation) {
              final bool isLandscape = orientation == Orientation.landscape;

              return Center(
                child: Container(
                  width: isLandscape
                      ? MediaQuery.of(context).size.width
                      : MediaQuery.of(context).size.width * 0.9,
                  height: isLandscape
                      ? MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.height * 0.6,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                    isLandscape ? null : BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: YoutubePlayer(
                          controller: _controller!,
                          showVideoProgressIndicator: true,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 28),
                          onPressed: () {
                            _controller?.pause();
                            Navigator.of(context).pop();
                            _controller?.dispose();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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
                      Container(color: Colors.grey[300]),

                      // Mostrar portada local si existe
                      if (rutina['portada'] != null)
                        Image.asset(
                          'assets/imgminis/miniyf/${rutina['portada']}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.network(
                                thumbnailUrl ??
                                    'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
                                fit: BoxFit.cover,
                              ),
                        )
                      else if (esPDF)
                        Image.asset(
                          'assets/images/pdf_thumb.jpg',
                          fit: BoxFit.cover,
                        )
                      else
                        Image.network(
                          thumbnailUrl ??
                              'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
                          fit: BoxFit.cover,
                        ),

                      Container(color: Colors.black.withOpacity(0.3)),

                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!esPDF)
                              const Icon(Icons.play_circle_fill,
                                  color: Colors.white, size: 50),
                            // ❌ títulos ocultos (están en la portada)
                            // const SizedBox(height: 6),
                            // Text(rutina['title'], ... )
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
