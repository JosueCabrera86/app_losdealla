import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RutinasScreen extends StatefulWidget {
  final List<Map<String, dynamic>> material;
  final int nivelUsuario;
  final VoidCallback? onClose;

  const RutinasScreen({super.key, required this.material, this.nivelUsuario = 20, this.onClose,});

  @override
  State<RutinasScreen> createState() => _RutinasScreenState();
}

class _RutinasScreenState extends State<RutinasScreen> {
  bool menuOpen = false;
  int imagenIndex = 0;
  YoutubePlayerController? _youtubeController;

  final List<Map<String, dynamic>> rutinasBase = [
    { 'categoria': 5, 'tipo': "pdf", 'title': "1. Frente y ojos", 'pdf': ["Frente-y-ojos-1.png"] },
    { 'categoria': 6, 'tipo': "video", 'title': "1. Frente y ojos", 'video': "https://www.youtube.com/embed/xW4U1i4XxJg" },
    { 'categoria': 7, 'tipo': "pdf", 'title': "2. Una rutina para ojos", 'pdf': ["Ojos-1.png"] },
    { 'categoria': 8, 'tipo': "video", 'title': "2. Una rutina para ojos", 'video': "https://www.youtube.com/embed/6tkfc-pobr0" },
    { 'categoria': 9, 'tipo': "pdf", 'title': "3. Línea facial y cuello", 'pdf': ["Linea-Facial-y-Cuello-1.png"] },
    { 'categoria': 10, 'tipo': "video", 'title': "3. Línea facial y cuello", 'video': "https://www.youtube.com/embed/Q6pmDrXMROs" },
    { 'categoria': 14, 'tipo': "pdf", 'title': "4. Nariz, labios y nasolabiales", 'pdf': ["Nariz-Labios-y-Nasolabiales-1.png", "Nariz-Labios-y-Nasolabiales-2.png", "Nariz-Labios-y-Nasolabiales-3.png", "Frente-y-ojos-4.png"] },
    { 'categoria': 15, 'tipo': "video", 'title': "4. Nariz, labios y nasolabiales", 'video': "https://www.youtube.com/embed/v0nMSc7bDEI" },
    { 'categoria': 17, 'tipo': "pdf", 'title': "5. Pómulos y sonrisa", 'pdf': ["Pomulos-y-Sonrisa-1.png", "Pomulos-y-Sonrisa-2.png", "Pomulos-y-Sonrisa-3.png", "Frente-y-ojos-4.png"] },
    { 'categoria': 18, 'tipo': "video", 'title': "5. Pómulos y sonrisa", 'video': "https://www.youtube.com/embed/uPnft5T1_Ps" },
    { 'categoria': 20, 'tipo': "video", 'title': "6. Acupresión avanzada", 'video': "https://www.youtube.com/embed/BoCZ0nkv58M" },
  ];

  List<Map<String, dynamic>> get rutinasFiltradas {
    final lista = widget.material.isNotEmpty ? widget.material : rutinasBase;
    return lista.where((r) => (r['categoria'] ?? 0) <= widget.nivelUsuario).toList();
  }

  void abrirModalRutina(Map<String, dynamic> rutina) {
    imagenIndex = 0;
    if (rutina['tipo'] == 'video') {
      _youtubeController = YoutubePlayerController(
        initialVideoId: rutina['video'],
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
                  rutina['title'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                if (rutina['tipo'] == 'pdf' && (rutina['pdf']?.length ?? 0) > 0)
                  Stack(
                    children: [
                      Image.asset(
                        'assets/imgsuscriptores/${rutina['pdf'][imagenIndex]}',
                        fit: BoxFit.contain,
                      ),
                      if (rutina['pdf'].length > 1)
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              setStateDialog(() {
                                imagenIndex = ((imagenIndex - 1 + rutina['pdf'].length) % rutina['pdf'].length).toInt();
                              });
                            },
                          ),
                        ),
                      if (rutina['pdf'].length > 1)
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              setStateDialog(() {
                                imagenIndex = ((imagenIndex + 1) % rutina['pdf'].length).toInt();
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                if (rutina['tipo'] == 'video' && rutina['video'] != null)
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
          child: Text(menuOpen ? 'Cerrar rutinas' : 'Rutinas de Yoga Facial'),
        ),
        if (menuOpen)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: rutinasFiltradas.map((rutina) {
              return GestureDetector(
                onTap: () => abrirModalRutina(rutina),
                child: Container(
                  width: 140,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.deepPurple[50],
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2,2))],
                  ),
                  child: Column(
                    children: [
                      if (rutina['tipo'] == 'pdf' && (rutina['pdf']?.isNotEmpty ?? false))
                        Image.asset(
                          'assets/imgsuscriptores/${rutina['pdf'][0]}',
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      if (rutina['tipo'] == 'video')
                        Container(
                          height: 80,
                          color: Colors.black12,
                          child: const Icon(Icons.play_circle_fill, size: 40, color: Colors.red),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        rutina['title'] ?? '',
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
