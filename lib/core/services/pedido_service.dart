import '../../data/model/pedido.dart';

final List<Pedido> _pedidos = [
  Pedido(id: "1", numeroOrden: "ORD-1042", clienteId: "1", clienteNombre: "María González", descripcionProducto: "Vestido de novia — encaje floral, cola 2m", estado: EstadoPedido.activo, progreso: EstadoProgreso.enProgreso, fecha: "15 Mar 2025"),
  Pedido(id: "2", numeroOrden: "ORD-1041", clienteId: "2", clienteNombre: "Carmen López", descripcionProducto: "Traje chaqueta entallado — lana fría azul marino", estado: EstadoPedido.activo, progreso: EstadoProgreso.controlCalidad, fecha: "12 Mar 2025"),
  Pedido(id: "3", numeroOrden: "ORD-1040", clienteId: "3", clienteNombre: "Isabel Martínez", descripcionProducto: "Blusa de seda — cuello lazo, color marfil", estado: EstadoPedido.activo, progreso: EstadoProgreso.entregado, fecha: "10 Mar 2025"),
  Pedido(id: "4", numeroOrden: "ORD-1039", clienteId: "4", clienteNombre: "Ana Fernández", descripcionProducto: "Falda plisada midi — poliéster reciclado", estado: EstadoPedido.completado, progreso: EstadoProgreso.entregado, fecha: "5 Mar 2025"),
  Pedido(id: "5", numeroOrden: "ORD-1038", clienteId: "5", clienteNombre: "Laura Sánchez", descripcionProducto: "Camisa oversize — algodón orgánico, rayas", estado: EstadoPedido.completado, progreso: EstadoProgreso.entregado, fecha: "28 Feb 2025"),
  Pedido(id: "6", numeroOrden: "ORD-1037", clienteId: "6", clienteNombre: "Sofía Ramírez", descripcionProducto: "Abrigo trench — gabardina beige clásica", estado: EstadoPedido.borrador, progreso: EstadoProgreso.enProgreso, fecha: "25 Feb 2025"),
  Pedido(id: "7", numeroOrden: "ORD-1036", clienteId: "7", clienteNombre: "Elena Torres", descripcionProducto: "Pantalón palazzo — crepé negro, talle alto", estado: EstadoPedido.borrador, progreso: EstadoProgreso.enProgreso, fecha: "20 Feb 2025"),
];

class PedidoService {
  static int _nextId = 8;
  static int _nextOrd = 1043;

  static Future<List<Pedido>> getPedidos() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_pedidos);
  }

  static Future<List<Pedido>> buscar(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) return List.from(_pedidos);
    final q = query.toLowerCase();
    return _pedidos.where((p) =>
        p.numeroOrden.toLowerCase().contains(q) ||
        p.clienteNombre.toLowerCase().contains(q) ||
        p.descripcionProducto.toLowerCase().contains(q)).toList();
  }

  static Future<List<Pedido>> filtrarPorEstado(EstadoPedido? estado) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (estado == null) return List.from(_pedidos);
    return _pedidos.where((p) => p.estado == estado).toList();
  }

  static Future<String> registrar(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final pedido = Pedido(
      id: (_nextId++).toString(),
      numeroOrden: "ORD-${_nextOrd++}",
      clienteId: data["clienteId"]?.toString() ?? "",
      clienteNombre: data["clienteNombre"] ?? "",
      descripcionProducto: data["descripcionProducto"] ?? "",
      estado: EstadoPedido.activo,
      progreso: EstadoProgreso.enProgreso,
      fecha: data["fecha"] ?? DateTime.now().toIso8601String(),
    );
    _pedidos.insert(0, pedido);
    return "Pedido registrado correctamente";
  }

  static Future<String> editar(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return "Pedido actualizado correctamente";
  }

  static Future<String> eliminar(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _pedidos.removeWhere((p) => p.id == id);
    return "Pedido eliminado";
  }
}
