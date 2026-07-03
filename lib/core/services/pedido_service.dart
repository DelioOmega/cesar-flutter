import '../../data/model/pedido.dart';
import 'api_client.dart';

// Servicio de pedidos. CRUD contra el backend via ApiClient.
class PedidoService {
  // GET /pedidos/ → devuelve la lista de pedidos.
  static Future<List<Pedido>> getPedidos() async {
    final data = await ApiClient.get('/pedidos/');
    if (data == null || data is! List) return [];
    return data
        .map((p) => Pedido.fromBackend(Map<String, dynamic>.from(p)))
        .toList();
  }

  // Busca pedidos por número, cliente o descripción (filtro local).
  static Future<List<Pedido>> buscar(String query) async {
    final pedidos = await getPedidos();
    if (query.isEmpty) return pedidos;
    final q = query.toLowerCase();
    return pedidos.where((p) =>
        p.numeroOrden.toLowerCase().contains(q) ||
        p.clienteNombre.toLowerCase().contains(q) ||
        p.descripcionProducto.toLowerCase().contains(q)).toList();
  }

  // Filtra pedidos por estado (filtro local).
  static Future<List<Pedido>> filtrarPorEstado(EstadoPedido? estado) async {
    final pedidos = await getPedidos();
    if (estado == null) return pedidos;
    return pedidos.where((p) => p.estado == estado).toList();
  }

  // POST /pedidos → registra un nuevo pedido.
  static Future<String> registrar(Map<String, dynamic> data) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final id = (ts % 99999).toString().padLeft(5, '0');

    final body = {
      "id": id,
      "id_cliente": data["id_cliente"]?.toString() ?? "",
      "tipo_pedido": data["tipo_pedido"]?.toString() ?? "",
      if (data["fecha_estimada"] != null && data["fecha_estimada"].toString().isNotEmpty)
        "fecha_estimada": data["fecha_estimada"].toString(),
      if (data["dias_recordatorio"] != null)
        "dias_recordatorio": data["dias_recordatorio"],
      if (data["precio_total_estimado"] != null)
        "precio_total_estimado": data["precio_total_estimado"],
      if (data["observacion"] != null && data["observacion"].toString().isNotEmpty)
        "observacion": data["observacion"].toString(),
    };

    final resp = await ApiClient.post('/pedidos', body);
    if (resp != null) {
      if (resp["message"] != null) return resp["message"];
      if (resp["mensaje"] != null) return resp["mensaje"];
    }
    return "Pedido registrado correctamente";
  }

  // PUT /pedidos/ — no implementado en el backend.
  // static Future<String> editar(Map<String, dynamic> data) async {
  //   return "Funcionalidad no disponible en el servidor";
  // }

  // DELETE /pedidos/$id → cancela/elimina un pedido.
  static Future<String> eliminar(String id) async {
    final ok = await ApiClient.delete('/pedidos/$id');
    return ok ? "Pedido cancelado" : "Error al cancelar pedido";
  }
}
