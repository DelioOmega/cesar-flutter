import '../../data/model/cliente.dart';
import 'api_client.dart';

// Servicio de clientes. CRUD contra el backend via ApiClient.
class ClienteService {
  // GET /clientes/ → devuelve la lista de clientes.
  static Future<List<Cliente>> getClientes() async {
    final data = await ApiClient.get('/clientes/');
    if (data == null || data is! List) return [];
    return data
        .map((c) => Cliente.fromBackend(Map<String, dynamic>.from(c)))
        .toList();
  }

  // Busca clientes por nombre (filtro local, no llama al backend).
  static Future<List<Cliente>> buscar(String query) async {
    final clientes = await getClientes();
    if (query.isEmpty) return clientes;
    final q = query.toLowerCase();
    return clientes
        .where((c) => c.nombreCompleto.toLowerCase().contains(q))
        .toList();
  }

  // POST /clientes/ → registra un nuevo cliente.
  static Future<String> registrar(
      Map<String, dynamic> data, String usuIdFk) async {
    final id = DateTime.now().millisecondsSinceEpoch;
    final body = {
      "cliId": id,
      "cliNom": data["nombre"] ?? "",
      "cliApe": data["apellido"] ?? "",
      "cliTel": data["telefono"] ?? "",
      "usuIdFk": int.tryParse(usuIdFk) ?? 0,
      "cliCorr": data["email"] ?? "",
    };

    final resp = await ApiClient.post('/clientes/', body);
    if (resp != null && resp["mensaje"] != null) {
      return resp["mensaje"];
    }
    return "Error al registrar cliente";
  }

  //  PUT /clientes/ — no implementado en el backend.
  static Future<String> editar(Map<String, dynamic> data) async {
    return "Funcionalidad no disponible en el servidor";
  }

  // DELETE /clientes/ — no implementado en el backend.
  static Future<String> eliminar(String id) async {
    return "Funcionalidad no disponible en el servidor";
  }
}
