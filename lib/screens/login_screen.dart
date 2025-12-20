
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class LoginScreen extends StatefulWidget {
  final String tipo;
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

    final supabase = Supabase.instance.client;

    try {

      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = res.user;
      final session = res.session;

      if (user == null || session == null) {
        setState(() => error = 'Credenciales incorrectas');
        return;
      }
      debugPrint('Auth user: ${user?.id}');
      debugPrint('Session: ${session?.accessToken != null}');


      await storage.write(
        key: 'token',
        value: session.accessToken,
      );

      final profile = await supabase
          .from('users')
          .select('*')
          .eq('auth_id', user.id)
          .single();

      final rol = profile['rol'];
      final disciplina = profile['disciplina'];



      await storage.write(key: 'user_id', value: profile['id'].toString());
      await storage.write(key: 'user_email', value: user.email);
      await storage.write(key: 'user_categoria',value: profile['categoria'].toString(),);
      await storage.write(key: 'user_disciplina', value: disciplina);
      await storage.write(key: 'user_rol', value: rol);


      if (widget.tipo == 'casino') {
        Navigator.pushReplacementNamed(context, '/vipcasino');
      } else {
        Navigator.pushReplacementNamed(context, '/suscriptoresyf');
      }
    } on AuthException catch (e) {
      setState(() => error = e.message);
    } catch (e) {
      setState(() => error = 'Error inesperado: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorLila = const Color(0xFF660099);
    final colorAzul = const Color(0xFFF9F9F9);

    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFEDCBF6),
      appBar: AppBar(
        toolbarHeight: 90,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: colorLila,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Material Adicional',
              style: TextStyle(
                color: colorAzul,
                fontSize: 18,
                  fontWeight: FontWeight.bold ),
            ),
            Text(
              widget.tipo == 'casino' ? 'Casino' : 'Yoga Facial',
              style: TextStyle(
                color: colorAzul,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),



      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double paddingHorizontal = isLandscape ? size.width * 0.2 : 24.0;
          double fontSizeTitle = isLandscape ? 18 : 20;
          double inputFontSize = isLandscape ? 14 : 16;

          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 16),
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
