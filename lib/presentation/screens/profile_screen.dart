import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/auth_controller.dart';
import '../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.usuario;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          // ── Avatar ──
          Stack(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: AppTheme.accent.withValues(alpha: 0.15),
                child: Text(
                  user != null && user.nombre.isNotEmpty
                      ? user.nombre[0].toUpperCase()
                      : "U",
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accent,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: AppTheme.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.edit,
                      size: 14, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Name & Role ──
          Text(
            user?.nombre ?? "Usuario",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.rol ?? "Sin rol asignado",
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textGrey,
            ),
          ),

          const SizedBox(height: 36),

          // ── Support section ──
          _MenuTile(
            icon: Icons.help_outline_rounded,
            title: "Centro de Ayuda",
            onTap: () {},
          ),
          const SizedBox(height: 6),
          _MenuTile(
            icon: Icons.mail_outline_rounded,
            title: "Contactar Atelier",
            onTap: () {},
          ),

          const SizedBox(height: 36),

          // ── Logout ──
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                auth.logout();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.accent,
                side: const BorderSide(color: AppTheme.accent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                "Cerrar Sesión",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon, color: AppTheme.textDark),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.textGrey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
