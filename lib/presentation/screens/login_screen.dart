import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _loading = true);

    final auth = context.read<AuthController>();
    final ok = await auth.login(_emailCtrl.text.trim(), _passCtrl.text);

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Credenciales incorrectas")),
      );
    }
  }

  void _olvidePassword() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Recuperar contraseña"),
        content: Text(
          "Se enviará un enlace a ${_emailCtrl.text.trim().isEmpty ? "tu correo" : _emailCtrl.text.trim()}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // ── Logo ──
                Container(
                  // ignore: physical-property-detected — Flutter, no CSS
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.checkroom_rounded,
                    size: 40,
                    color: AppTheme.accent,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "ona&nel",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                    letterSpacing: 1,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  "TALLER DE COSTURA",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textGrey,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 48),

                // ── Email ──
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Correo electrónico",
                    prefixIcon: Icon(Icons.mail_outline, color: AppTheme.textGrey),
                  ),
                ),

                const SizedBox(height: 14),

                // ── Password ──
                TextField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintText: "Contraseña",
                    prefixIcon:
                        const Icon(Icons.lock_outline, color: AppTheme.textGrey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                        color: AppTheme.textGrey,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  onSubmitted: (_) => _login(),
                ),

                const SizedBox(height: 8),

                // ── Olvidé contraseña ──
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _olvidePassword,
                    child: const Text(
                      "Olvidé mi contraseña",
                      style: TextStyle(
                        color: AppTheme.accent,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Login button ──
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("INICIAR SESIÓN"),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Register link ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "¿Aún no tienes una cuenta?  ",
                      style: TextStyle(
                        color: AppTheme.textGrey,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Funcionalidad próximamente"),
                          ),
                        );
                      },
                      child: const Text(
                        "REGISTRARSE",
                        style: TextStyle(
                          color: AppTheme.accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
