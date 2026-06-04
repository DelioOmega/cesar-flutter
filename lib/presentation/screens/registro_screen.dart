import 'package:flutter/material.dart';
import '../../core/services/usuario_service.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final cNombre = TextEditingController();
  final cApellido = TextEditingController();
  final cCorreo = TextEditingController();
  final cPassword = TextEditingController();

  String genero = "Masculino";
  String rol = "Admin";

  bool loading = false;

  void registrar() async {
    setState(() => loading = true);

    try {
      final resp = await UsuarioService.registrar({
        'USU_NOMBRES': cNombre.text.trim(),
        'USU_APELLIDOS': cApellido.text.trim(),
        'USU_CORREO': cCorreo.text.trim(),
        'USU_ROL': rol,
        'USU_GENERO': genero,
        'USU_PASSWORD': cPassword.text,
      });

      mostrarMensaje(resp);

    } catch (e) {
      mostrarMensaje("Error al registrar");
    }

    setState(() => loading = false);
  }

  void mostrarMensaje(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Mensaje"),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Usuario")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: cNombre, decoration: const InputDecoration(labelText: "Nombres")),
            TextField(controller: cApellido, decoration: const InputDecoration(labelText: "Apellidos")),
            TextField(controller: cCorreo, decoration: const InputDecoration(labelText: "Correo")),
            TextField(controller: cPassword, obscureText: true, decoration: const InputDecoration(labelText: "Password")),

            const SizedBox(height: 15),

            DropdownButton<String>(
              value: genero,
              isExpanded: true,
              items: ["Masculino", "Femenino"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => genero = v!),
            ),

            DropdownButton<String>(
              value: rol,
              isExpanded: true,
              items: ["Admin", "Supervisor"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => rol = v!),
            ),

            const SizedBox(height: 20),

            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: registrar,
                    child: const Text("Registrar"),
                  )
          ],
        ),
      ),
    );
  }
}