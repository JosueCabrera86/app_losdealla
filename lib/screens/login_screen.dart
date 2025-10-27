import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  final String tipo; // 'yoga' o 'casino'
  const LoginScreen({super.key, required this.tipo});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  String? error;
  bool loading = false;

  Future<void> handleSubmit() async {
    setState(() {
      error = null;
      loading = true;
    });

    try {
      final res = await http.post(
        Uri.parse('https://backendlda.onrender.com/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // Guardar token en memoria temporal
        // (puedes usar SharedPreferences si quieres persistencia)
        // Aquí solo simulo
        final token = data['token'];

        // Navegar según tipo
        if (widget.tipo == 'casino' || data['rol'] == 'casino') {
          Navigator.pushReplacementNamed(context, '/casino');
        } else {
          Navigator.pushReplacementNamed(context, '/suscriptoresyf');
        }
      } else {
        setState(() {
          error = data['error'] ?? 'Error en el inicio de sesión';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error en el servidor';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorLila = const Color(0xFF660099);
    final colorAzul = const Color(0xFF330066);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.tipo == 'casino'
            ? 'Material Adicional Casino'
            : 'Material Adicional Yoga Facial'),
        backgroundColor: colorLila,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Inicia sesión para continuar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorLila,
                ),
              ),
              const SizedBox(height: 24),

              // 🟣 Campo Email
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: colorLila.withOpacity(0.6)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorLila),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorAzul, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 🟣 Campo Contraseña
              TextField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  hintStyle: TextStyle(color: colorLila.withOpacity(0.6)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility_off : Icons.visibility,
                      color: colorLila,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorLila),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: colorAzul, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // 🛑 Error message
              if (error != null)
                Text(
                  error!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),

              const SizedBox(height: 24),

              // 🟢 Botón iniciar sesión
              ElevatedButton(
                onPressed: loading ? null : handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorLila,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: loading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
