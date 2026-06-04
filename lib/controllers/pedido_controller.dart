import 'package:flutter/foundation.dart';
import '../core/services/pedido_service.dart';
import '../data/model/pedido.dart';

class PedidoController extends ChangeNotifier {
  List<Pedido> _pedidos = [];
  List<Pedido> _pedidosFiltrados = [];
  bool _loading = false;
  String? _error;
  String _query = "";
  EstadoPedido? _filtroEstado;

  List<Pedido> get pedidos => _pedidosFiltrados;
  List<Pedido> get pedidosActivos =>
      _pedidosFiltrados.where((p) => p.estado == EstadoPedido.activo).toList();
  bool get loading => _loading;
  String? get error => _error;
  String get query => _query;
  EstadoPedido? get filtroEstado => _filtroEstado;

  Future<void> cargarPedidos() async {
    _loading = true;
    notifyListeners();

    try {
      _pedidos = await PedidoService.getPedidos();
      _aplicarFiltros();
      _error = null;
    } catch (e) {
      _error = "Error al cargar pedidos";
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> buscar(String q) async {
    _query = q;
    _loading = true;
    notifyListeners();

    if (q.isEmpty) {
      _pedidos = await PedidoService.getPedidos();
    } else {
      _pedidos = await PedidoService.buscar(q);
    }

    _aplicarFiltros();
    _loading = false;
    notifyListeners();
  }

  void setFiltroEstado(EstadoPedido? estado) {
    _filtroEstado = estado;
    _aplicarFiltros();
    notifyListeners();
  }

  Future<String> registrar(Map<String, dynamic> data) async {
    final resp = await PedidoService.registrar(data);
    await cargarPedidos();
    return resp;
  }

  Future<String> editar(Map<String, dynamic> data) async {
    final resp = await PedidoService.editar(data);
    await cargarPedidos();
    return resp;
  }

  Future<void> eliminar(String id) async {
    await PedidoService.eliminar(id);
    await cargarPedidos();
  }

  void _aplicarFiltros() {
    _pedidosFiltrados = List.from(_pedidos);
    if (_filtroEstado != null) {
      _pedidosFiltrados =
          _pedidosFiltrados.where((p) => p.estado == _filtroEstado).toList();
    }
  }
}
