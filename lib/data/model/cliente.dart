class Cliente {
  final String id;
  final String nombre;
  final String apellido;
  final String telefono;
  final String email;
  final String? avatar;
  final String? fechaUltimoPedido;

  Cliente({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
    this.avatar,
    this.fechaUltimoPedido,
  });

  String get nombreCompleto => "$nombre $apellido";

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json["id"]?.toString() ?? "",
      nombre: json["nombre"] ?? "",
      apellido: json["apellido"] ?? "",
      telefono: json["telefono"] ?? "",
      email: json["email"] ?? "",
      avatar: json["avatar"],
      fechaUltimoPedido: json["fechaUltimoPedido"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apellido": apellido,
        "telefono": telefono,
        "email": email,
        "avatar": avatar,
        "fechaUltimoPedido": fechaUltimoPedido,
      };

  Cliente copyWith({
    String? id,
    String? nombre,
    String? apellido,
    String? telefono,
    String? email,
    String? avatar,
    String? fechaUltimoPedido,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      fechaUltimoPedido: fechaUltimoPedido ?? this.fechaUltimoPedido,
    );
  }
}
