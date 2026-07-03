import 'package:flutter/foundation.dart';
import '../core/services/cliente_service.dart';
import '../data/model/cliente.dart';

// Controlador de clientes. Gestiona lista, búsqueda y CRUD.
// Mantiene dos listas: una completa y otra filtrada para la UI.
class ClienteController extends ChangeNotifier {
  List<Cliente> _clientes = [];          // lista completa
  List<Cliente> _clientesFiltrados = []; // lista mostrada en UI
  bool _loading = false;
  String? _error;
  String _query = "";

  List<Cliente> get clientes => _clientesFiltrados;
  bool get loading => _loading;
  String? get error => _error;
  String get query => _query;

  // GET /clientes/ → carga todos los clientes.
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

  // Busca clientes por nombre (filtro local).
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

  // POST /clientes/ → registra y recarga.
  Future<String> registrar(Map<String, dynamic> data, String usuIdFk) async {
    final resp = await ClienteService.registrar(data, usuIdFk);
    await cargarClientes();
    return resp;
  }

  //  PUT /clientes/ — no implementado en backend.
  Future<String> editar(Map<String, dynamic> data) async {
    final resp = await ClienteService.editar(data);
    await cargarClientes();
    return resp;
  }

  //  DELETE /clientes/ — no implementado en backend.
  Future<void> eliminar(String id) async {
    await ClienteService.eliminar(id);
    await cargarClientes();
  }

  // Aplica el filtro de búsqueda sobre la lista completa.
  void _aplicarFiltro() {
    if (_query.isEmpty) {
      _clientesFiltrados = List.from(_clientes);
    }
  }
}
