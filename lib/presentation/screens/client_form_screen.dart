import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/cliente_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../data/model/cliente.dart';

class ClientFormScreen extends StatefulWidget {
  final Cliente? cliente;

  const ClientFormScreen({super.key, this.cliente});

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _apellidoCtrl;
  late final TextEditingController _telefonoCtrl;
  late final TextEditingController _emailCtrl;
  bool _loading = false;

  bool get _isEditing => widget.cliente != null;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.cliente?.nombre ?? "");
    _apellidoCtrl =
        TextEditingController(text: widget.cliente?.apellido ?? "");
    _telefonoCtrl =
        TextEditingController(text: widget.cliente?.telefono ?? "");
    _emailCtrl = TextEditingController(text: widget.cliente?.email ?? "");
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _apellidoCtrl.dispose();
    _telefonoCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    setState(() => _loading = true);

    final data = {
      if (_isEditing) "id": widget.cliente!.id,
      "nombre": _nombreCtrl.text.trim(),
      "apellido": _apellidoCtrl.text.trim(),
      "telefono": _telefonoCtrl.text.trim(),
      "email": _emailCtrl.text.trim(),
    };

    final controller = context.read<ClienteController>();
    String resp;
    if (_isEditing) {
      resp = await controller.editar(data);
    } else {
      resp = await controller.registrar(data);
    }

    if (!mounted) return;
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(resp)),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? "Editar Cliente" : "Nuevo Cliente"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Avatar placeholder ──
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: AppTheme.accent.withValues(alpha: 0.15),
                    child: Text(
                      _nombreCtrl.text.isNotEmpty
                          ? _nombreCtrl.text[0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accent,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Fields ──
            TextField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _apellidoCtrl,
              decoration: const InputDecoration(labelText: "Apellido"),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _telefonoCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Teléfono"),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: "Correo electrónico"),
            ),

            const SizedBox(height: 32),

            // ── Save button ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _guardar,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_isEditing ? "Guardar Cambios" : "Registrar Cliente"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
