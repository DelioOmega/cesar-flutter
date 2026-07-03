import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/cliente_controller.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/client_card.dart';
import '../widgets/search_bar_widget.dart';
import 'client_form_screen.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClienteController>().cargarClientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ClienteController>();

    return Stack(
      children: [
        Column(
          children: [
            // ── Search bar ──
            SearchBarWidget(
              hint: "Buscar clientes por nombre...",
              onChanged: (q) => controller.buscar(q),
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
                                onPressed: () => controller.cargarClientes(),
                                child: const Text("Reintentar"),
                              ),
                            ],
                          ),
                        )
                      : controller.clientes.isEmpty
                          ? const Center(
                              child: Text(
                                "No se encontraron clientes",
                                style: TextStyle(color: AppTheme.textGrey),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(top: 4, bottom: 90),
                              itemCount: controller.clientes.length,
                              itemBuilder: (_, i) {
                                final c = controller.clientes[i];
                                return ClientCard(
                                  cliente: c,
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ClientFormScreen(cliente: c),
                                      ),
                                    );
                                    controller.cargarClientes();
                                  },
                                  onLongPress: () =>
                                      _confirmarEliminar(context, c.id),
                                );
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
            heroTag: null,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ClientFormScreen(),
                ),
              );
              controller.cargarClientes();
            },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _confirmarEliminar(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar cliente"),
        content: const Text("¿Estás segura de eliminar este cliente?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ClienteController>().eliminar(id);
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
