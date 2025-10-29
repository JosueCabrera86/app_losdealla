import 'package:flutter/material.dart';
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
  int? _seleccionIndex;
  Map<String, dynamic>? _seleccionado;

  final List<Map<String, dynamic>> base = [
    {'categoria': 4, 'tipo': 'video', 'title': 'Posición Cerrada', 'video': 'u2OEmNMYTCw'},
    {'categoria': 4, 'tipo': 'video', 'title': 'Desplazamientos', 'video': 'K4bLW4_-w9Q'},
    {'categoria': 4, 'tipo': 'video', 'title': 'Sácala y peinate', 'video': 'gYRVZobHOeE'},
    {'categoria': 4, 'tipo': 'video', 'title': 'Rodeo', 'video': 'gYRVZobHOeE'},
    {'categoria': 4, 'tipo': 'video', 'title': 'Pasea y Pasea con sácala', 'video': 'gYRVZobHOeE'},
    {'categoria': 4, 'tipo': 'video', 'title': 'Dile que no', 'video': 'gYRVZobHOeE'},
  ];

  List<Map<String, dynamic>> get filtrado =>
      base.where((m) => (m['categoria'] ?? 0) <= widget.nivelUsuario).toList();

  void abrirRutina(Map<String, dynamic> rutina) {
    setState(() {
      _seleccionado = rutina;
      _seleccionIndex = 0;
    });
  }

  void cerrarRutina() {
    setState(() {
      _seleccionado = null;
      _seleccionIndex = null;
    });
  }

  void cambiarPDF(int dir) {
    if (_seleccionado?['pdf'] == null) return;
    final total = (_seleccionado!['pdf'] as List).length;
    setState(() {
      _seleccionIndex = (_seleccionIndex! + dir + total) % total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: widget.onClose, child: const Text('Cerrar Nivel Avanzado')),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtrado.length,
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            final rutina = filtrado[index];
            return ElevatedButton(
              onPressed: () => abrirRutina(rutina),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(rutina['title']),
                  Text(rutina['tipo'] == 'pdf' ? 'PDF' : 'Video'),
                ],
              ),
            );
          },
        ),
        if (_seleccionado != null)
          Center(
            child: Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 400,
                child: Stack(
                  children: [
                    if (_seleccionado!['tipo'] == 'pdf')
                      Center(
                        child: Image.asset(
                          'assets/images/${_seleccionado!['pdf'][_seleccionIndex!]}',
                          fit: BoxFit.contain,
                        ),
                      ),
                    if (_seleccionado!['tipo'] == 'video')
                      YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: _seleccionado!['video'],
                          flags: const YoutubePlayerFlags(autoPlay: false),
                        ),
                        showVideoProgressIndicator: true,
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(icon: const Icon(Icons.close), onPressed: cerrarRutina),
                    ),
                    if (_seleccionado!['tipo'] == 'pdf' && (_seleccionado!['pdf'] as List).length > 1)
                      Positioned(
                        left: 8,
                        top: 180,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_left, size: 32),
                          onPressed: () => cambiarPDF(-1),
                        ),
                      ),
                    if (_seleccionado!['tipo'] == 'pdf' && (_seleccionado!['pdf'] as List).length > 1)
                      Positioned(
                        right: 8,
                        top: 180,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_right, size: 32),
                          onPressed: () => cambiarPDF(1),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
