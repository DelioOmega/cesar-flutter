enum EstadoPedido {
  pendiente,
  enProceso,
  terminado,
  cancelado,
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
  final String? tipoPedido;
  final String? observacion;
  final double? precioEstimado;

  Pedido({
    required this.id,
    required this.numeroOrden,
    required this.clienteId,
    required this.clienteNombre,
    required this.descripcionProducto,
    required this.estado,
    required this.progreso,
    required this.fecha,
    this.tipoPedido,
    this.observacion,
    this.precioEstimado,
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

  /// Convierte desde el formato del backend
  factory Pedido.fromBackend(Map<String, dynamic> json) {
    final estadoRaw = json["pedEstFk"]?.toString() ?? "";
    return Pedido(
      id: json["pedId"]?.toString() ?? "",
      numeroOrden: json["pedId"]?.toString() ?? "",
      clienteId: json["pedCliIdFk"]?.toString() ?? "",
      clienteNombre: "", // Se rellena desde el controller con join local
      descripcionProducto: json["pedObs"] ?? "",
      estado: _parseEstadoBackend(estadoRaw),
      progreso: EstadoProgreso.enProgreso,
      fecha: json["pedFecIng"]?.toString() ?? "",
      tipoPedido: json["pedTipPedFk"]?.toString(),
      observacion: json["pedObs"],
      precioEstimado: json["pedTolEst"] != null
          ? double.tryParse(json["pedTolEst"].toString())
          : null,
    );
  }

  static EstadoPedido _parseEstadoBackend(String s) {
    switch (s.toUpperCase()) {
      case "PENDIENTE":
        return EstadoPedido.pendiente;
      case "EN PROCESO":
      case "EN_PROCESO":
        return EstadoPedido.enProceso;
      case "TERMINADO":
      case "ENTREGADO":
      case "COMPLETADO":
        return EstadoPedido.terminado;
      case "CANCELADO":
        return EstadoPedido.cancelado;
      default:
        return EstadoPedido.pendiente;
    }
  }

  static EstadoPedido _parseEstado(String? s) {
    switch (s?.toUpperCase()) {
      case "PENDIENTE":
        return EstadoPedido.pendiente;
      case "EN PROCESO":
      case "EN_PROCESO":
        return EstadoPedido.enProceso;
      case "TERMINADO":
      case "ENTREGADO":
      case "COMPLETADO":
        return EstadoPedido.terminado;
      case "CANCELADO":
        return EstadoPedido.cancelado;
      default:
        return EstadoPedido.pendiente;
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
