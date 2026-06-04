enum EstadoPedido {
  activo,
  completado,
  borrador,
}

enum EstadoProgreso {
  enProgreso,
  controlCalidad,
  entregado,
}

class Pedido {
  final String id;
  final String numeroOrden;
  final String clienteId;
  final String clienteNombre;
  final String descripcionProducto;
  final EstadoPedido estado;
  final EstadoProgreso progreso;
  final String fecha;

  Pedido({
    required this.id,
    required this.numeroOrden,
    required this.clienteId,
    required this.clienteNombre,
    required this.descripcionProducto,
    required this.estado,
    required this.progreso,
    required this.fecha,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json["id"]?.toString() ?? "",
      numeroOrden: json["numeroOrden"] ?? "",
      clienteId: json["clienteId"]?.toString() ?? "",
      clienteNombre: json["clienteNombre"] ?? "",
      descripcionProducto: json["descripcionProducto"] ?? "",
      estado: _parseEstado(json["estado"]),
      progreso: _parseProgreso(json["progreso"]),
      fecha: json["fecha"] ?? "",
    );
  }

  static EstadoPedido _parseEstado(String? s) {
    switch (s) {
      case "completado":
        return EstadoPedido.completado;
      case "borrador":
        return EstadoPedido.borrador;
      default:
        return EstadoPedido.activo;
    }
  }

  static EstadoProgreso _parseProgreso(String? s) {
    switch (s) {
      case "controlCalidad":
        return EstadoProgreso.controlCalidad;
      case "entregado":
        return EstadoProgreso.entregado;
      default:
        return EstadoProgreso.enProgreso;
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "numeroOrden": numeroOrden,
        "clienteId": clienteId,
        "clienteNombre": clienteNombre,
        "descripcionProducto": descripcionProducto,
        "estado": estado.name,
        "progreso": progreso.name,
        "fecha": fecha,
      };
}
