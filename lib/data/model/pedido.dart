/// Estados posibles de un pedido (mapeados desde `pedEstFk` del backend).
enum EstadoPedido {
  pendiente,
  enProceso,
  terminado,
  cancelado,
}

/// Progreso interno del pedido (no se usa actualmente en la UI).
enum EstadoProgreso {
  enProgreso,
  controlCalidad,
  entregado,
}

/// Modelo que representa un pedido del taller.
///
/// Mapea los campos del backend (`pedId`, `pedCliIdFk`, `pedEstFk`, etc.)
/// a propiedades Dart. El [clienteNombre] se rellena desde el controller
/// mediante un join local con la lista de clientes.
class Pedido {
  /// ID único del pedido (`pedId` en backend).
  final String id;

  /// Número de orden visible (actualmente igual a [id]).
  final String numeroOrden;

  /// ID del cliente asociado (`pedCliIdFk`).
  final String clienteId;

  /// Nombre del cliente (se rellena desde el controller, no del backend).
  final String clienteNombre;

  /// Descripción del producto / observación del pedido (`pedObs`).
  final String descripcionProducto;

  /// Estado actual del pedido (parseado desde `pedEstFk`).
  final EstadoPedido estado;

  /// Progreso interno (no se usa actualmente en la UI).
  final EstadoProgreso progreso;

  /// Fecha de ingreso del pedido (`pedFecIng`).
  final String fecha;

  /// Tipo de pedido: PERSONALIZADO, RETOQUES, MODIFICACIONES (`pedTipPedFk`).
  final String? tipoPedido;

  /// Observaciones adicionales (`pedObs`).
  final String? observacion;

  /// Precio total estimado (`pedTolEst`), opcional.
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

  /// Construye un [Pedido] desde un JSON con formato local.
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

  /// Construye un [Pedido] desde el formato JSON del backend.
  ///
  /// Mapeo de campos:
  /// - `pedId` → [id], [numeroOrden]
  /// - `pedCliIdFk` → [clienteId]
  /// - `pedObs` → [descripcionProducto], [observacion]
  /// - `pedEstFk` → [estado] (parseado por [_parseEstadoBackend])
  /// - `pedFecIng` → [fecha]
  /// - `pedTipPedFk` → [tipoPedido]
  /// - `pedTolEst` → [precioEstimado]
  ///
  /// [clienteNombre] se deja vacío y se rellena después en el controller.
  factory Pedido.fromBackend(Map<String, dynamic> json) {
    final estadoRaw = json["pedEstFk"]?.toString() ?? "";
    return Pedido(
      id: json["pedId"]?.toString() ?? "",
      numeroOrden: json["pedId"]?.toString() ?? "",
      clienteId: json["pedCliIdFk"]?.toString() ?? "",
      clienteNombre: "",
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

  /// Parsea el estado desde el formato del backend.
  ///
  /// | Backend | EstadoPedido |
  /// |---|---|
  /// | PENDIENTE | pendiente |
  /// | EN PROCESO / EN_PROCESO | enProceso |
  /// | TERMINADO / ENTREGADO / COMPLETADO | terminado |
  /// | CANCELADO | cancelado |
  /// | otro valor | pendiente (default) |
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

  /// Parsea el estado desde un JSON local.
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

  /// Parsea el progreso interno (formato local).
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

  /// Convierte el [Pedido] a JSON (formato local).
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
