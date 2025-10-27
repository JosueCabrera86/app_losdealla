import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NivelAvanzado extends StatefulWidget {
  final List<Map<String, dynamic>> material;
  final int nivelUsuario;

  const NivelAvanzado({super.key, required this.material, this.nivelUsuario = 4});

  @override
  State<NivelAvanzado> createState() => _NivelAvanzadoState();
}

class _NivelAvanzadoState extends State<NivelAvanzado> {
  bool menuOpen = false;
  Map<String, dynamic>? avanzadoSeleccionado;
  YoutubePlayerController? _youtubeController;

  void toggleMenu() {
    setState(() {
      menuOpen = !menuOpen;
      avanzadoSeleccionado = null;
      _youtubeController?.pause();
      _youtubeController = null; // limpiar al cerrar menú
    });
  }

  void abrirModal(Map<String, dynamic> rutina) {
    final videoUrl = rutina['video'] ?? '';
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);

    if (rutina['tipo'] == 'video' && videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    } else {
      _youtubeController = null;
    }

    setState(() {
      avanzadoSeleccionado = rutina;
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
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
                      _youtubeController = null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    rutina['title'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                if (_youtubeController != null)
                  YoutubePlayer(
                    controller: _youtubeController!,
                    showVideoProgressIndicator: true,
                  ),
                if (_youtubeController == null && rutina['tipo'] == 'video')
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Video no disponible",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rutinasFiltradas = widget.material
        .where((item) => (item['categoria'] ?? 0) <= widget.nivelUsuario)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: toggleMenu,
            child: Text(menuOpen ? 'Cerrar clases' : 'Nivel Avanzado'),
          ),
          if (menuOpen)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: rutinasFiltradas.map((rutina) {
                return ElevatedButton(
                  onPressed: () => abrirModal(rutina),
                  child: Column(
                    children: [
                      Text(rutina['title'] ?? ''),
                      Text(rutina['tipo'] == 'pdf' ? 'PDF' : 'Video'),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
