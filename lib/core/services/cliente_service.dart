import '../../data/model/cliente.dart';

/// Mock data + simulated network delays.
/// Replace with real ApiService calls when backend is ready.

final List<Cliente> _clientes = [
  Cliente(id: "1", nombre: "María", apellido: "González", telefono: "+34 612 345 678", email: "maria@email.com", fechaUltimoPedido: "15 Mar 2025"),
  Cliente(id: "2", nombre: "Carmen", apellido: "López", telefono: "+34 623 456 789", email: "carmen@email.com", fechaUltimoPedido: "10 Mar 2025"),
  Cliente(id: "3", nombre: "Isabel", apellido: "Martínez", telefono: "+34 634 567 890", email: "isabel@email.com", fechaUltimoPedido: "8 Mar 2025"),
  Cliente(id: "4", nombre: "Ana", apellido: "Fernández", telefono: "+34 645 678 901", email: "ana@email.com", fechaUltimoPedido: "5 Mar 2025"),
  Cliente(id: "5", nombre: "Laura", apellido: "Sánchez", telefono: "+34 656 789 012", email: "laura@email.com", fechaUltimoPedido: "2 Mar 2025"),
  Cliente(id: "6", nombre: "Sofía", apellido: "Ramírez", telefono: "+34 667 890 123", email: "sofia@email.com", fechaUltimoPedido: "28 Feb 2025"),
  Cliente(id: "7", nombre: "Elena", apellido: "Torres", telefono: "+34 678 901 234", email: "elena@email.com", fechaUltimoPedido: "20 Feb 2025"),
  Cliente(id: "8", nombre: "Paula", apellido: "Díaz", telefono: "+34 689 012 345", email: "paula@email.com", fechaUltimoPedido: "18 Feb 2025"),
];

class ClienteService {
  static int _nextId = 9;

  static Future<List<Cliente>> getClientes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_clientes);
  }

  static Future<List<Cliente>> buscar(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) return List.from(_clientes);
    final q = query.toLowerCase();
    return _clientes
        .where((c) => c.nombreCompleto.toLowerCase().contains(q))
        .toList();
  }

  static Future<String> registrar(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final cliente = Cliente(
      id: (_nextId++).toString(),
      nombre: data["nombre"] ?? "",
      apellido: data["apellido"] ?? "",
      telefono: data["telefono"] ?? "",
      email: data["email"] ?? "",
      fechaUltimoPedido: null,
    );
    _clientes.insert(0, cliente);
    return "Cliente registrado correctamente";
  }

  static Future<String> editar(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final id = data["id"]?.toString();
    final idx = _clientes.indexWhere((c) => c.id == id);
    if (idx >= 0) {
      _clientes[idx] = _clientes[idx].copyWith(
        nombre: data["nombre"],
        apellido: data["apellido"],
        telefono: data["telefono"],
        email: data["email"],
      );
    }
    return "Cliente actualizado correctamente";
  }

  static Future<String> eliminar(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _clientes.removeWhere((c) => c.id == id);
    return "Cliente eliminado";
  }
}
