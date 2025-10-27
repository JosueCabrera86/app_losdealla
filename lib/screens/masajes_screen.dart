import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MasajesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> material;
  final int nivelUsuario;

  const MasajesScreen({super.key, required this.material, this.nivelUsuario = 20});

  @override
  State<MasajesScreen> createState() => _MasajesScreenState();
}

class _MasajesScreenState extends State<MasajesScreen> {
  bool menuOpen = false;
  Map<String, dynamic>? masajeSeleccionado;
  int imagenIndex = 0;
  YoutubePlayerController? _youtubeController;

  final List<Map<String, dynamic>> masajesBase = [
    {'categoria': 2, 'tipo': 'video', 'title': 'Masaje periférico', 'video': 'SJ20LZe3RxI'},
    {'categoria': 3, 'tipo': 'video', 'title': 'Masaje de reseteo facial', 'video': 'sG2qqWv9T9Y'},
    {'categoria': 4, 'tipo': 'video', 'title': 'Masaje de preparación facial', 'video': 'OUBvlbA8_Fk'},
    {'categoria': 9, 'tipo': 'video', 'title': 'Masaje con guasha', 'video': 'jPAeiOlCrv0'},
    {'categoria': 13, 'tipo': 'video', 'title': 'Masaje relajante', 'video': 'ke_h99NelDM'},
    {'categoria': 19, 'tipo': 'pdf', 'title': 'Masaje de acupresión', 'pdf': ['Acupresion-avanzados.png']},
  ];

  List<Map<String, dynamic>> get masajesFiltrados {
    final lista = widget.material.isNotEmpty ? widget.material : masajesBase;
    return lista.where((m) => (m['categoria'] ?? 0) <= widget.nivelUsuario).toList();
  }

  void toggleMenu() {
    setState(() {
      menuOpen = !menuOpen;
      masajeSeleccionado = null;
      imagenIndex = 0;
    });
  }

  void abrirModal(Map<String, dynamic> masaje) {
    setState(() {
      masajeSeleccionado = masaje;
      imagenIndex = 0;
      if (masaje['tipo'] == 'video') {
        _youtubeController = YoutubePlayerController(
          initialVideoId: masaje['video'],
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
                  masaje['title'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                if (masaje['tipo'] == 'pdf' && (masaje['pdf']?.length ?? 0) > 0)
                  Stack(
                    children: [
                      Image.asset(
                        'assets/imgsuscriptores/${masaje['pdf'][imagenIndex]}',
                        fit: BoxFit.contain,
                      ),
                      if (masaje['pdf'].length > 1)
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              setStateDialog(() {
                                imagenIndex = (imagenIndex - 1 + masaje['pdf'].length) % masaje['pdf'].length;
                              });
                            },
                          ),
                        ),
                      if (masaje['pdf'].length > 1)
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              setStateDialog(() {
                                imagenIndex = (imagenIndex + 1) % masaje['pdf'].length;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                if (masaje['tipo'] == 'video' && masaje['video'] != null)
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
          child: Text(menuOpen ? 'Cerrar' : 'Masajes previos a tu rutina'),
        ),
        if (menuOpen)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: masajesFiltrados.map((masaje) {
              return ElevatedButton(
                onPressed: () => abrirModal(masaje),
                child: Column(
                  children: [
                    Text(masaje['title'] ?? ''),
                    Text(masaje['tipo'] == 'pdf' ? 'PDF' : 'Video'),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
