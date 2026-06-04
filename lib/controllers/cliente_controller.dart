import 'package:flutter/foundation.dart';
import '../core/services/cliente_service.dart';
import '../data/model/cliente.dart';

class ClienteController extends ChangeNotifier {
  List<Cliente> _clientes = [];
  List<Cliente> _clientesFiltrados = [];
  bool _loading = false;
  String? _error;
  String _query = "";

  List<Cliente> get clientes => _clientesFiltrados;
  bool get loading => _loading;
  String? get error => _error;
  String get query => _query;

  Future<void> cargarClientes() async {
    _loading = true;
    notifyListeners();

    try {
      _clientes = await ClienteService.getClientes();
      _aplicarFiltro();
      _error = null;
    } catch (e) {
      _error = "Error al cargar clientes";
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> buscar(String q) async {
    _query = q;

    if (q.isEmpty) {
      _clientesFiltrados = List.from(_clientes);
      notifyListeners();
      return;
    }

    _loading = true;
    notifyListeners();

    _clientesFiltrados = await ClienteService.buscar(q);

    _loading = false;
    notifyListeners();
  }

  Future<String> registrar(Map<String, dynamic> data) async {
    final resp = await ClienteService.registrar(data);
    await cargarClientes();
    return resp;
  }

  Future<String> editar(Map<String, dynamic> data) async {
    final resp = await ClienteService.editar(data);
    await cargarClientes();
    return resp;
  }

  Future<void> eliminar(String id) async {
    await ClienteService.eliminar(id);
    await cargarClientes();
  }

  void _aplicarFiltro() {
    if (_query.isEmpty) {
      _clientesFiltrados = List.from(_clientes);
    }
  }
}
