import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MasajesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> material;
  final int nivelUsuario;
  final VoidCallback? onClose;

  const MasajesScreen({super.key, required this.material, this.nivelUsuario = 20,  this.onClose});

  @override
  State<MasajesScreen> createState() => _MasajesScreenState();
}

class _MasajesScreenState extends State<MasajesScreen> {
  bool menuOpen = false;
  int imagenIndex = 0;
  YoutubePlayerController? _youtubeController;

  final List<Map<String, dynamic>> masajesBase = [
    { 'categoria': 2, 'tipo': "video", 'title': 'Masaje periférico', 'url': 'https://www.youtube.com/embed/SJ20LZe3RxI' },
    { 'categoria': 3, 'tipo': "video", 'title': 'Masaje de reseteo facial', 'url': 'https://www.youtube.com/embed/sG2qqWv9T9Y' },
    { 'categoria': 4, 'tipo': "video", 'title': 'Masaje de preparación facial', 'url': 'https://www.youtube.com/embed/OUBvlbA8_Fk' },
    { 'categoria': 9, 'tipo': "video", 'title': 'Masaje con guasha', 'url': 'https://www.youtube.com/embed/jPAeiOlCrv0' },
    { 'categoria': 13, 'tipo': "video", 'title': 'Masaje relajante', 'url': 'https://www.youtube.com/embed/ke_h99NelDM' },
    { 'categoria': 19, 'tipo': "pdf", 'title': "Masaje de acupresión", 'pdf': ["Acupresion-avanzados.png"] },

  ];

  List<Map<String, dynamic>> get masajesFiltrados {
    final lista = widget.material.isNotEmpty ? widget.material : masajesBase;
    return lista.where((m) => (m['categoria'] ?? 0) <= widget.nivelUsuario).toList();
  }

  void abrirModalMasaje(Map<String, dynamic> masaje) {
    imagenIndex = 0;
    if (masaje['tipo'] == 'video') {
      _youtubeController = YoutubePlayerController(
        initialVideoId: masaje['video'],
        flags: const YoutubePlayerFlags(autoPlay: false),
      );
    }

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
                        _youtubeController?.pause(); // Pausa video si hay
                        Navigator.pop(context); // Cierra el modal
                        // Si quieres ejecutar algo al cerrar, lo puedes descomentar
                        // if (widget.onClose != null) widget.onClose!();
                      },
                    )
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
                                imagenIndex = ((imagenIndex - 1 + masaje['pdf'].length) % masaje['pdf'].length).toInt();
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
                                imagenIndex = ((imagenIndex + 1) % masaje['pdf'].length).toInt();
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
          onPressed: () => setState(() => menuOpen = !menuOpen),
          child: Text(menuOpen ? 'Cerrar' : 'Masajes previos a tu rutina'),
        ),
        if (menuOpen)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: masajesFiltrados.map((masaje) {
              return GestureDetector(
                onTap: () => abrirModalMasaje(masaje),
                child: Container(
                  width: 140,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.pink[50],
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2,2))],
                  ),
                  child: Column(
                    children: [
                      if (masaje['tipo'] == 'pdf' && (masaje['pdf']?.isNotEmpty ?? false))
                        Image.asset(
                          'assets/imgsuscriptores/${masaje['pdf'][0]}',
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      if (masaje['tipo'] == 'video')
                        Container(
                          height: 80,
                          color: Colors.black12,
                          child: const Icon(Icons.play_circle_fill, size: 40, color: Colors.red),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        masaje['title'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
