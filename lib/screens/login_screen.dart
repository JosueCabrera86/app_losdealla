import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  final String tipo; // 'yoga' o 'casino'
  const LoginScreen({super.key, required this.tipo});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();

  bool showPassword = false;
  bool loading = false;
  String? error;

  Future<void> handleSubmit() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => error = 'Por favor llena todos los campos');
      return;
    }

    setState(() {
      error = null;
      loading = true;
    });

    try {
      final url = Uri.parse('https://backendlda.onrender.com/login');
      print('🔹 Intentando conexión con $url');
      print('🔹 Datos enviados: $email / $password');

      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('🔹 Status code: ${res.statusCode}');
      print('🔹 Body: ${res.body}');

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 && data['token'] != null) {
        final token = data['token'];
        final rol = data['rol'] ?? widget.tipo;

        await storage.write(key: 'token', value: token);
        await storage.write(key: 'rol', value: rol);

        if (rol == 'casino' || widget.tipo == 'casino') {
          Navigator.pushReplacementNamed(context, '/vipcasino');
        } else {
          Navigator.pushReplacementNamed(context, '/suscriptoresyf');
        }
      } else {
        setState(() => error = data['error'] ?? 'Credenciales incorrectas');
      }
    } catch (e) {
      print('🚨 Error al conectar con el servidor: $e');
      setState(() => error = 'Error al conectar con el servidor: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorLila = const Color(0xFF660099);
    final colorAzul = const Color(0xFF330066);

    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true, // ✅ Centra el título en todas las pantallas
        title: Text(
          widget.tipo == 'casino'
              ? 'Material Adicional Casino'
              : 'Material Adicional Yoga Facial',
          textAlign: TextAlign.center,
        ),
        backgroundColor: colorLila,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double paddingHorizontal = isLandscape ? size.width * 0.2 : 24.0;
          double fontSizeTitle = isLandscape ? 18 : 20;
          double inputFontSize = isLandscape ? 14 : 16;

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Inicia sesión para continuar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.bold,
                        color: colorLila,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: inputFontSize),
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
                    TextField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      style: TextStyle(fontSize: inputFontSize),
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                        hintStyle: TextStyle(color: colorLila.withOpacity(0.6)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPassword ? Icons.visibility_off : Icons.visibility,
                            color: colorLila,
                          ),
                          onPressed: () => setState(() => showPassword = !showPassword),
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
                    if (error != null)
                      Text(
                        error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: loading ? null : handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorLila,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        'Iniciar sesión',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
