import '../../data/model/cliente.dart';
import 'api_client.dart';

class ClienteService {
  static Future<List<Cliente>> getClientes() async {
    final data = await ApiClient.get('/clientes/');
    if (data == null || data is! List) return [];
    return data
        .map((c) => Cliente.fromBackend(Map<String, dynamic>.from(c)))
        .toList();
  }

  static Future<List<Cliente>> buscar(String query) async {
    final clientes = await getClientes();
    if (query.isEmpty) return clientes;
    final q = query.toLowerCase();
    return clientes
        .where((c) => c.nombreCompleto.toLowerCase().contains(q))
        .toList();
  }

  static Future<String> registrar(
      Map<String, dynamic> data, String usuIdFk) async {
    // Generar un id numérico basado en timestamp
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

  static Future<String> editar(Map<String, dynamic> data) async {
    // El backend actual no tiene PUT /clientes/
    return "Funcionalidad no disponible en el servidor";
  }

  static Future<String> eliminar(String id) async {
    // El backend actual no tiene DELETE /clientes/
    return "Funcionalidad no disponible en el servidor";
  }
}
