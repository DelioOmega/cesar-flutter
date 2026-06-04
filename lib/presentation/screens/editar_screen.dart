import 'package:flutter/material.dart';

import '../../core/services/usuario_service.dart';
import '../../data/model/usuario.dart';
 

class EditarScreen extends StatefulWidget {
  final Usuario user;

  const EditarScreen({super.key, required this.user});

  @override
  State<EditarScreen> createState() => _EditarScreenState();
}

class _EditarScreenState extends State<EditarScreen> {
  late TextEditingController cNombre;
  late TextEditingController cApellido;
  late TextEditingController cCorreo;
  final cPassword = TextEditingController();

  String genero = "Masculino";
  String rol = "Admin";

  bool loading = false;

  @override
  void initState() {
    super.initState();

    cNombre = TextEditingController(text: widget.user.nombres);
    cApellido = TextEditingController(text: widget.user.apellidos);
    cCorreo = TextEditingController(text: widget.user.correo);

    genero = widget.user.genero;
    rol = widget.user.rol;
  }

  void editar() async {
    setState(() => loading = true);

    try {
      final resp = await UsuarioService.editar({
        'USU_ID': widget.user.id.toString(),
        'USU_NOMBRES': cNombre.text,
        'USU_APELLIDOS': cApellido.text,
        'USU_CORREO': cCorreo.text,
        'USU_ROL': rol,
        'USU_GENERO': genero,
        'USU_PASSWORD': cPassword.text,
      });

      mostrarMensaje(resp);

    } catch (e) {
      mostrarMensaje("Error al editar");
    }

    setState(() => loading = false);
  }

  void eliminar() async {
    setState(() => loading = true);

    await UsuarioService.eliminar(widget.user.id);

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (route) => false);
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
      appBar: AppBar(
        title: const Text("Editar Usuario"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: eliminar,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: cNombre, decoration: const InputDecoration(labelText: "Nombres")),
            TextField(controller: cApellido, decoration: const InputDecoration(labelText: "Apellidos")),
            TextField(controller: cCorreo, decoration: const InputDecoration(labelText: "Correo")),
            TextField(controller: cPassword, obscureText: true, decoration: const InputDecoration(labelText: "Nueva Password")),

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
                    onPressed: editar,
                    child: const Text("Guardar Cambios"),
                  )
          ],
        ),
      ),
    );
  }
}