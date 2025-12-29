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

  // Colores definidos para consistencia
  final colorLilaProfundo = const Color(0xFF512DA8);
  final colorFondoLila = const Color(0xFFF3E5F5);
  final colorBlancoHueso = const Color(0xFFF9F9F9);

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


      final profile = await supabase
          .from('users')
          .select('*')
          .eq('auth_id', user.id)
          .single();


      final disciplinaUsuario = profile['disciplina']?.toString().trim().toLowerCase() ?? '';
      final disciplinaPantalla = widget.tipo.trim().toLowerCase();

      if (!disciplinaUsuario.contains(disciplinaPantalla) && !disciplinaPantalla.contains(disciplinaUsuario)) {
        await supabase.auth.signOut();
        setState(() => error = 'Tu cuenta pertenece a otra disciplina.');
        return;
      }

      await storage.write(key: 'token', value: session.accessToken);
      await storage.write(key: 'user_id', value: profile['id'].toString());
      await storage.write(key: 'user_email', value: user.email);
      await storage.write(key: 'user_categoria', value: profile['categoria'].toString());
      await storage.write(key: 'user_disciplina', value: profile['disciplina']);
      await storage.write(key: 'user_rol', value: profile['rol']);


      if (disciplinaPantalla.contains('casino')) {
        Navigator.pushReplacementNamed(context, '/vipcasino');
      } else if (disciplinaPantalla.contains('yoga')) {
        Navigator.pushReplacementNamed(context, '/suscriptoresyf');}

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
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      backgroundColor: colorFondoLila,
      appBar: AppBar(
        toolbarHeight: isLandscape ? 70 : 85,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: colorLilaProfundo,
        elevation: 0,
        title: Column(
          children: [
            const Text(
              'Material Adicional',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            Text(
              widget.tipo == 'casino' ? 'Casino' : 'Yoga Facial',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isLandscape ? size.width * 0.15 : 24.0,
            vertical: 20,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Bienvenid@',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isLandscape ? 22 : 26,
                    fontWeight: FontWeight.bold,
                    color: colorLilaProfundo,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Inicia sesión para continuar',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                const SizedBox(height: 32),


                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined, color: colorLilaProfundo),
                    filled: true,
                    fillColor: Colors.white70,
                    labelStyle: TextStyle(color: colorLilaProfundo),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorLilaProfundo.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorLilaProfundo, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),


                TextField(
                  controller: passwordController,
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock_outline, color: colorLilaProfundo),
                    filled: true,
                    fillColor: Colors.white70,
                    labelStyle: TextStyle(color: colorLilaProfundo),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility,
                        color: colorLilaProfundo,
                      ),
                      onPressed: () => setState(() => showPassword = !showPassword),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorLilaProfundo.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorLilaProfundo, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                if (error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                  ),
                ],

                const SizedBox(height: 32),


                ElevatedButton(
                  onPressed: loading ? null : handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorLilaProfundo,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: loading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}