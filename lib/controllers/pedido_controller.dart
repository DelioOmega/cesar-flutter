import 'package:flutter/foundation.dart';
import '../core/services/pedido_service.dart';
import '../core/services/cliente_service.dart';
import '../data/model/pedido.dart';
import '../data/model/cliente.dart';

// Controlador de pedidos. Gestiona lista, búsqueda, filtros y CRUD.
// Hace join local con clientes para rellenar clienteNombre.
class PedidoController extends ChangeNotifier {
  List<Pedido> _pedidos = [];           // lista completa
  List<Pedido> _pedidosFiltrados = [];  // lista mostrada en UI
  bool _loading = false;
  String? _error;
  String _query = "";
  EstadoPedido? _filtroEstado;

  List<Pedido> get pedidos => _pedidosFiltrados;
  List<Pedido> get pedidosActivos =>
      _pedidosFiltrados.where((p) => p.estado == EstadoPedido.enProceso).toList();
  bool get loading => _loading;
  String? get error => _error;
  String get query => _query;
  EstadoPedido? get filtroEstado => _filtroEstado;

  // GET /pedidos/ + GET /clientes/ → carga todo y hace join local.
  Future<void> cargarPedidos() async {
    _loading = true;
    notifyListeners();

    try {
      final resultados = await Future.wait([
        PedidoService.getPedidos(),
        ClienteService.getClientes(),
      ]);
      final pedidosRaw = resultados[0] as List<Pedido>;
      final clientes = (resultados[1] as List).cast<Cliente>();

      // Mapa: id del cliente → nombre completo
      final mapaClientes = {
        for (final c in clientes) c.id: c.nombreCompleto,
      };

      // Rellenar clienteNombre en cada pedido
      _pedidos = pedidosRaw.map((p) {
        final nombreCliente =
            mapaClientes[p.clienteId] ?? "Cliente ${p.clienteId}";
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

      _aplicarFiltros();
      _error = null;
    } catch (e) {
      _error = "Error al cargar pedidos";
    }

    _loading = false;
    notifyListeners();
  }

  // Busca pedidos (filtro local). Si q está vacío recarga.
  Future<void> buscar(String q) async {
    _query = q;
    _loading = true;
    notifyListeners();

    if (q.isEmpty) {
      await cargarPedidos();
    } else {
      _pedidos = await PedidoService.buscar(q);
      _aplicarFiltros();
    }

    _loading = false;
    notifyListeners();
  }

  // Cambia el filtro de estado.
  void setFiltroEstado(EstadoPedido? estado) {
    _filtroEstado = estado;
    _aplicarFiltros();
    notifyListeners();
  }

  // POST /pedidos → registra y recarga.
  Future<String> registrar(Map<String, dynamic> data) async {
    final resp = await PedidoService.registrar(data);
    await cargarPedidos();
    return resp;
  }

  // // PUT /pedidos/ — no implementado.
  // Future<String> editar(Map<String, dynamic> data) async {
  //   final resp = await PedidoService.editar(data);
  //   await cargarPedidos();
  //   return resp;
  // }

  // DELETE /pedidos/$id → elimina y recarga.
  Future<void> eliminar(String id) async {
    await PedidoService.eliminar(id);
    await cargarPedidos();
  }

  // Aplica filtros de búsqueda y estado.
  void _aplicarFiltros() {
    _pedidosFiltrados = List.from(_pedidos);
    if (_filtroEstado != null) {
      _pedidosFiltrados = _pedidosFiltrados
          .where((p) => p.estado == _filtroEstado)
          .toList();
    }
  }
}
