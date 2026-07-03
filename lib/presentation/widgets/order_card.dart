import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/model/pedido.dart';

class OrderCard extends StatelessWidget {
  final Pedido pedido;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const OrderCard({
    super.key,
    required this.pedido,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Row 1: Order number + status badge ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pedido.numeroOrden,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.textDark,
                  ),
                ),
                _buildBadge(pedido.estado),
              ],
            ),

            const SizedBox(height: 8),

            // ── Row 2: Client name ──
            Text(
              pedido.clienteNombre,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: AppTheme.textDark,
              ),
            ),

            const SizedBox(height: 4),

            // ── Row 3: Product description ──
            Text(
              pedido.descripcionProducto,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(EstadoPedido estado) {
    Color color = AppTheme.textGrey;
    String label = "—";

    switch (estado) {
      case EstadoPedido.pendiente:
        color = AppTheme.orangeStatus;
        label = "PENDIENTE";
        break;
      case EstadoPedido.enProceso:
        color = AppTheme.blueStatus;
        label = "EN PROCESO";
        break;
      case EstadoPedido.terminado:
        color = AppTheme.greenStatus;
        label = "TERMINADO";
        break;
      case EstadoPedido.cancelado:
        color = AppTheme.textGrey;
        label = "CANCELADO";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
