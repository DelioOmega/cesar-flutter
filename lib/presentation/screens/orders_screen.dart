import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/pedido_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../data/model/pedido.dart';
import '../widgets/order_card.dart';
import '../widgets/search_bar_widget.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PedidoController>().cargarPedidos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<PedidoController>();

    return Stack(
      children: [
        Column(
          children: [
            // ── Search bar ──
            SearchBarWidget(
              hint: "Buscar pedidos o clientes...",
              onChanged: (q) => controller.buscar(q),
            ),

            // ── Filter chips ──
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  _FilterChip(
                    label: "Todos",
                    isSelected: controller.filtroEstado == null,
                    onTap: () => controller.setFiltroEstado(null),
                  ),
                  _FilterChip(
                    label: "Activos",
                    isSelected: controller.filtroEstado == EstadoPedido.activo,
                    onTap: () =>
                        controller.setFiltroEstado(EstadoPedido.activo),
                  ),
                  _FilterChip(
                    label: "Completados",
                    isSelected:
                        controller.filtroEstado == EstadoPedido.completado,
                    onTap: () =>
                        controller.setFiltroEstado(EstadoPedido.completado),
                  ),
                  _FilterChip(
                    label: "Borradores",
                    isSelected:
                        controller.filtroEstado == EstadoPedido.borrador,
                    onTap: () =>
                        controller.setFiltroEstado(EstadoPedido.borrador),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // ── Section title ──
            if (controller.filtroEstado == EstadoPedido.activo)
              _SectionHeader(
                title: "Pedidos Activos",
                count: controller.pedidosActivos.length,
              ),

            // ── List ──
            Expanded(
              child: controller.loading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 48, color: AppTheme.textGrey),
                              const SizedBox(height: 8),
                              Text(controller.error!),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () => controller.cargarPedidos(),
                                child: const Text("Reintentar"),
                              ),
                            ],
                          ),
                        )
                      : controller.pedidos.isEmpty
                          ? const Center(
                              child: Text(
                                "No se encontraron pedidos",
                                style: TextStyle(color: AppTheme.textGrey),
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.only(top: 4, bottom: 90),
                              itemCount: controller.pedidos.length,
                              itemBuilder: (_, i) {
                                return OrderCard(pedido: controller.pedidos[i]);
                              },
                            ),
            ),
          ],
        ),

        // ── FAB ──
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Nuevo pedido — próximamente")),
              );
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.accent : AppTheme.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.accent.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppTheme.textGrey,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;

  const _SectionHeader({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "$count",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
