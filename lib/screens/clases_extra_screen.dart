import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ClasesExtraScreen extends StatefulWidget {
  final List<Map<String, dynamic>> material;
  final int nivelUsuario;
  final VoidCallback? onClose;

  const ClasesExtraScreen({super.key, required this.material, this.nivelUsuario = 20,  this.onClose});

  @override
  State<ClasesExtraScreen> createState() => _ClasesExtraScreenState();
}

class _ClasesExtraScreenState extends State<ClasesExtraScreen> {
  bool menuOpen = false;
  int imagenIndex = 0;
  YoutubePlayerController? _youtubeController;

  final List<Map<String, dynamic>> clasesBase = [
    { 'categoria': 1, 'tipo': "pdf", 'title': "Clase introductoria", 'pdf': ["portadainfo.png", "info9.png", "info10.png", "info11.png", "info12.png", "Frente-y-ojos-4.png"] },
    { 'categoria': 1, 'tipo': "video", 'title': "Clase introductoria", 'video': "https://www.youtube.com/embed/u2OEmNMYTCw" },
    { 'categoria': 4, 'tipo': "video", 'title': "Clase 1", 'video': "https://www.youtube.com/embed/K4bLW4_-w9Q" },
    { 'categoria': 10, 'tipo': "video", 'title': "Clase 2", 'video': "https://www.youtube.com/embed/gYRVZobHOeE" },
    { 'categoria': 16, 'tipo': "video", 'title': "Clase 3", 'video': "https://www.youtube.com/embed/iBkVM0zyLRc" },
    { 'categoria': 21, 'tipo': "video", 'title': "Clase especial de Kinesiotape", 'video': "https://www.youtube.com/embed/iozMsfyRchA" },

  ];

  List<Map<String, dynamic>> get clasesFiltradas {
    final lista = widget.material.isNotEmpty ? widget.material : clasesBase;
    return lista.where((m) => (m['categoria'] ?? 0) <= widget.nivelUsuario).toList();
  }

  void abrirModalClase(Map<String, dynamic> clase) {
    imagenIndex = 0;
    if (clase['tipo'] == 'video') {
      _youtubeController = YoutubePlayerController(
        initialVideoId: clase['video'],
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
          onPressed: () => setState(() => menuOpen = !menuOpen),
          child: Text(menuOpen ? 'Cerrar clases' : 'Material extra Yoga Facial'),
        ),
        if (menuOpen)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: clasesFiltradas.map((clase) {
              return GestureDetector(
                onTap: () => abrirModalClase(clase),
                child: Container(
                  width: 140,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.cyan[50],
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2,2))],
                  ),
                  child: Column(
                    children: [
                      if (clase['tipo'] == 'pdf' && (clase['pdf']?.isNotEmpty ?? false))
                        Image.asset(
                          'assets/imgsuscriptores/${clase['pdf'][0]}',
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      if (clase['tipo'] == 'video')
                        Container(
                          height: 80,
                          color: Colors.black12,
                          child: const Icon(Icons.play_circle_fill, size: 40, color: Colors.red),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        clase['title'] ?? '',
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