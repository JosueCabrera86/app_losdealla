import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ClasesExtraScreen extends StatefulWidget {
  final List<Map<String, dynamic>> material;
  final int nivelUsuario;

  const ClasesExtraScreen({super.key, required this.material, this.nivelUsuario = 20});

  @override
  State<ClasesExtraScreen> createState() => _ClasesExtraScreenState();
}

class _ClasesExtraScreenState extends State<ClasesExtraScreen> {
  bool menuOpen = false;
  Map<String, dynamic>? claseSeleccionada;
  int imagenIndex = 0;
  YoutubePlayerController? _youtubeController;

  final List<Map<String, dynamic>> clasesBase = [
    {
      'categoria': 1,
      'tipo': 'pdf',
      'title': 'Clase introductoria',
      'pdf': [
        'portadainfo.png',
        'info9.png',
        'info10.png',
        'info11.png',
        'info12.png',
        'Frente-y-ojos-4.png'
      ]
    },
    {'categoria': 1, 'tipo': 'video', 'title': 'Clase introductoria', 'video': 'u2OEmNMYTCw'},
    {'categoria': 4, 'tipo': 'video', 'title': 'Clase 1', 'video': 'K4bLW4_-w9Q'},
    {'categoria': 10, 'tipo': 'video', 'title': 'Clase 2', 'video': 'gYRVZobHOeE'},
    {'categoria': 16, 'tipo': 'video', 'title': 'Clase 3', 'video': 'iBkVM0zyLRc'},
    {'categoria': 21, 'tipo': 'video', 'title': 'Clase especial de Kinesiotape', 'video': 'iozMsfyRchA'},
  ];

  List<Map<String, dynamic>> get clasesFiltradas {
    final lista = widget.material.isNotEmpty ? widget.material : clasesBase;
    return lista.where((m) => (m['categoria'] ?? 0) <= widget.nivelUsuario).toList();
  }

  void toggleMenu() {
    setState(() {
      menuOpen = !menuOpen;
      claseSeleccionada = null;
      imagenIndex = 0;
    });
  }

  void abrirModal(Map<String, dynamic> clase) {
    setState(() {
      claseSeleccionada = clase;
      imagenIndex = 0;
      if (clase['tipo'] == 'video') {
        _youtubeController = YoutubePlayerController(
          initialVideoId: clase['video'],
          flags: const YoutubePlayerFlags(autoPlay: false),
        );
      }
    });

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(builder: (context, setStateDialog) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _youtubeController?.pause();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Text(
                  clase['title'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                if (clase['tipo'] == 'pdf' && (clase['pdf']?.length ?? 0) > 0)
                  Stack(
                    children: [
                      Image.asset(
                        'assets/imgsuscriptores/${clase['pdf'][imagenIndex]}',
                        fit: BoxFit.contain,
                      ),
                      if (clase['pdf'].length > 1)
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              setStateDialog(() {
                                imagenIndex = (imagenIndex - 1 + clase['pdf'].length) % clase['pdf'].length;
                              });
                            },
                          ),
                        ),
                      if (clase['pdf'].length > 1)
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              setStateDialog(() {
                                imagenIndex = (imagenIndex + 1) % clase['pdf'].length;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                if (clase['tipo'] == 'video' && clase['video'] != null)
                  YoutubePlayer(controller: _youtubeController!),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: toggleMenu,
          child: Text(menuOpen ? 'Cerrar clases' : 'Material extra Yoga Facial'),
        ),
        if (menuOpen)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: clasesFiltradas.map((clase) {
              return ElevatedButton(
                onPressed: () => abrirModal(clase),
                child: Column(
                  children: [
                    Text(clase['title'] ?? ''),
                    Text(clase['tipo'] == 'pdf' ? 'PDF' : 'Video'),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
