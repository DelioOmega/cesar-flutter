import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../core/services/cliente_service.dart';
import '../../core/services/pedido_service.dart';
import '../../core/theme/app_theme.dart';
import '../../data/model/pedido.dart';
import '../../data/model/cliente.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Pedido> _todos = [];
  List<Pedido> _recentes = [];
  List<Cliente> _clientes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargarDatos());
  }

  Future<void> _cargarDatos() async {
    try {
      final results = await Future.wait([
        PedidoService.getPedidos(),
        ClienteService.getClientes(),
      ]);
      _todos = results[0] as List<Pedido>;
      _clientes = results[1] as List<Cliente>;

      final mapaClientes = {
        for (final c in _clientes) c.id: c.nombreCompleto,
      };

      // Ordenar por fecha más reciente
      _todos.sort((a, b) {
        final fa = _parseFecha(a.fecha);
        final fb = _parseFecha(b.fecha);
        return fb.compareTo(fa);
      });

      // Rellenar nombre de cliente y tomar 3
      _recentes = _todos.take(3).map((p) {
        final nombreCliente = mapaClientes[p.clienteId] ?? "Cliente ${p.clienteId}";
        return Pedido(
          id: p.id,
          numeroOrden: p.numeroOrden,
          clienteId: p.clienteId,
          clienteNombre: nombreCliente,
          descripcionProducto: p.descripcionProducto,
          estado: p.estado,
          progreso: p.progreso,
          fecha: p.fecha,
          tipoPedido: p.tipoPedido,
          observacion: p.observacion,
          precioEstimado: p.precioEstimado,
        );
      }).toList();
    } catch (_) {
      _todos = [];
      _recentes = [];
    }
    if (mounted) setState(() => _loading = false);
  }

  DateTime _parseFecha(String fecha) {
    try {
      return DateTime.parse(fecha);
    } catch (_) {
      return DateTime(2000);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final nombre = auth.usuario?.nombre ?? "Usuario";

    // Contar estados del total de pedidos
    final enProceso = _todos.where((p) => p.estado == EstadoPedido.enProceso).length;
    final terminados = _todos.where((p) => p.estado == EstadoPedido.terminado).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Welcome ──
          const Text(
            "Bienvenido,",
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textGrey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            nombre,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),

          const SizedBox(height: 28),

          // ── Quick stats ──
          Row(
            children: [
              _StatCard(
                icon: Icons.people_outline,
                label: "Clientes",
                value: "${_clientes.length}",
                color: AppTheme.accent,
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.receipt_long_outlined,
                label: "Pedidos activos",
                value: "$enProceso",
                color: AppTheme.blueStatus,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _StatCard(
                icon: Icons.check_circle_outline,
                label: "Terminados",
                value: "$terminados",
                color: AppTheme.greenStatus,
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.edit_note,
                label: "Total pedidos",
                value: "${_todos.length}",
                color: AppTheme.orangeStatus,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // ── Recent orders section ──
          const Text(
            "PEDIDOS RECIENTES",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.textGrey,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),

          if (_loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_recentes.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "No hay pedidos recientes",
                  style: TextStyle(color: AppTheme.textGrey),
                ),
              ),
            )
          else
            ..._recentes.map((p) => _RecentOrder(
              orderNumber: p.numeroOrden,
              client: p.clienteNombre,
              product: p.tipoPedido != null
                  ? "${p.tipoPedido} — ${p.descripcionProducto}"
                  : p.descripcionProducto,
            )),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentOrder extends StatelessWidget {
  final String orderNumber;
  final String client;
  final String product;

  const _RecentOrder({
    required this.orderNumber,
    required this.client,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.checkroom, color: AppTheme.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderNumber,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppTheme.textDark,
                  ),
                ),
                Text(
                  "$client — $product",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
