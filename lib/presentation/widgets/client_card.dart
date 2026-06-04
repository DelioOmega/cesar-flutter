import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/model/cliente.dart';

class ClientCard extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ClientCard({
    super.key,
    required this.cliente,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor:
              cliente.avatar != null ? null : AppTheme.accent.withValues(alpha: 0.15),
          backgroundImage:
              cliente.avatar != null ? NetworkImage(cliente.avatar!) : null,
          child: cliente.avatar == null
              ? Text(
                  cliente.nombre.isNotEmpty ? cliente.nombre[0].toUpperCase() : "?",
                  style: const TextStyle(
                    color: AppTheme.accent,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : null,
        ),
        title: Text(
          cliente.nombreCompleto,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          cliente.telefono,
          style: const TextStyle(color: AppTheme.textGrey, fontSize: 13),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "LAST ORDER",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppTheme.textGrey,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              cliente.fechaUltimoPedido ?? "—",
              style: const TextStyle(fontSize: 12, color: AppTheme.textDark),
            ),
          ],
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
