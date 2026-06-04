import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Welcome ──
          const Text(
            "Bienvenida,",
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textGrey,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            "Elena",
            style: TextStyle(
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
                value: "8",
                color: AppTheme.accent,
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.receipt_long_outlined,
                label: "Pedidos activos",
                value: "3",
                color: AppTheme.blueStatus,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _StatCard(
                icon: Icons.check_circle_outline,
                label: "Completados",
                value: "2",
                color: AppTheme.greenStatus,
              ),
              const SizedBox(width: 12),
              _StatCard(
                icon: Icons.edit_note,
                label: "Borradores",
                value: "2",
                color: AppTheme.orangeStatus,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // ── Upcoming section ──
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

          _RecentOrder(
            orderNumber: "ORD-1042",
            client: "María González",
            product: "Vestido de novia — encaje floral",
          ),
          _RecentOrder(
            orderNumber: "ORD-1041",
            client: "Carmen López",
            product: "Traje chaqueta entallado — lana fría",
          ),
          _RecentOrder(
            orderNumber: "ORD-1040",
            client: "Isabel Martínez",
            product: "Blusa de seda — cuello lazo",
          ),
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
