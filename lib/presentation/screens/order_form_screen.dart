import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/pedido_controller.dart';
import '../../core/services/cliente_service.dart';
import '../../core/theme/app_theme.dart';
import '../../data/model/cliente.dart';

class OrderFormScreen extends StatefulWidget {
  const OrderFormScreen({super.key});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _clienteId;
  String? _tipoPedido;
  final _fechaEstimadaCtrl = TextEditingController();
  final _diasRecordatorioCtrl = TextEditingController();
  final _precioEstimadoCtrl = TextEditingController();
  final _observacionCtrl = TextEditingController();

  bool _loading = false;
  bool _cargandoClientes = true;
  List<Cliente> _clientes = [];

  @override
  void initState() {
    super.initState();
    // Cargar clientes después del primer frame para no interferir con el build
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargarClientes());
  }

  Future<void> _cargarClientes() async {
    try {
      _clientes = await ClienteService.getClientes();
    } catch (_) {
      _clientes = [];
    }
    if (mounted) setState(() => _cargandoClientes = false);
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),

    );
    if (picked != null) {
      _fechaEstimadaCtrl.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_clienteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona un cliente")),
      );
      return;
    }

    setState(() => _loading = true);

    final data = <String, dynamic>{
      "id_cliente": _clienteId,
      "tipo_pedido": _tipoPedido,
    };

    if (_fechaEstimadaCtrl.text.isNotEmpty) {
      data["fecha_estimada"] = _fechaEstimadaCtrl.text.trim();
    }
    if (_diasRecordatorioCtrl.text.isNotEmpty) {
      data["dias_recordatorio"] = int.tryParse(_diasRecordatorioCtrl.text.trim());
    }
    if (_precioEstimadoCtrl.text.isNotEmpty) {
      data["precio_total_estimado"] = double.tryParse(_precioEstimadoCtrl.text.trim());
    }
    if (_observacionCtrl.text.isNotEmpty) {
      data["observacion"] = _observacionCtrl.text.trim();
    }

    final controller = context.read<PedidoController>();
    final resp = await controller.registrar(data);

    if (!mounted) return;
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(resp)),
    );
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _fechaEstimadaCtrl.dispose();
    _diasRecordatorioCtrl.dispose();
    _precioEstimadoCtrl.dispose();
    _observacionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Pedido")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Cliente (select) ──
              const Text(
                "Cliente",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 6),
              _cargandoClientes
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : DropdownButtonFormField<String>(
                      value: _clienteId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        hintText: "Seleccionar cliente",
                      ),
                      items: _clientes.map((c) {
                        return DropdownMenuItem(
                          value: c.id,
                          child: Text(
                            c.nombreCompleto,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => _clienteId = v),
                      validator: (v) =>
                          v == null ? "Selecciona un cliente" : null,
                    ),
              const SizedBox(height: 18),

              // ── Tipo de pedido (select) ──
              const Text(
                "Tipo de pedido",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _tipoPedido,
                isExpanded: true,
                decoration: const InputDecoration(
                  hintText: "Seleccionar tipo",
                ),
                items: const [
                  DropdownMenuItem(
                    value: "PERSONALIZADO",
                    child: Text("Personalizado"),
                  ),
                  DropdownMenuItem(
                    value: "RETOQUES",
                    child: Text("Retoques"),
                  ),
                  DropdownMenuItem(
                    value: "MODIFICACIONES",
                    child: Text("Modificaciones"),
                  ),
                ],
                onChanged: (v) => setState(() => _tipoPedido = v),
                validator: (v) =>
                    v == null ? "Selecciona un tipo de pedido" : null,
              ),
              const SizedBox(height: 14),

              // ── Fecha estimada ──
              TextFormField(
                controller: _fechaEstimadaCtrl,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Fecha estimada (opcional)",
                  suffixIcon: Icon(Icons.calendar_today, color: AppTheme.accent),
                ),
                onTap: _seleccionarFecha,
              ),
              const SizedBox(height: 14),

              // ── Días recordatorio ──
              TextFormField(
                controller: _diasRecordatorioCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Días recordatorio (opcional)",
                ),
              ),
              const SizedBox(height: 14),

              // ── Precio estimado ──
              TextFormField(
                controller: _precioEstimadoCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Precio total estimado (opcional)",
                  prefixText: "\$ ",
                ),
              ),
              const SizedBox(height: 14),

              // ── Observación ──
              TextFormField(
                controller: _observacionCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Observación (opcional)",
                  hintText: "Detalles adicionales...",
                ),
              ),

              const SizedBox(height: 32),

              // ── Botón guardar ──
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
                      : const Text("Registrar Pedido"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
