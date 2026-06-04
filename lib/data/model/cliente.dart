class Cliente {
  final String id;
  final String nombre;
  final String apellido;
  final String telefono;
  final String? telefono2;
  final String email;
  final String? avatar;
  final String? fechaUltimoPedido;
  final String? direccion;

  Cliente({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    this.telefono2,
    required this.email,
    this.avatar,
    this.fechaUltimoPedido,
    this.direccion,
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

  /// Convierte desde el formato del backend (cliNom, cliApe, cliTel, cliCorr…)
  factory Cliente.fromBackend(Map<String, dynamic> json) {
    return Cliente(
      id: json["cliId"]?.toString() ?? "",
      nombre: json["cliNom"] ?? "",
      apellido: json["cliApe"] ?? "",
      telefono: json["cliTel"]?.toString() ?? "",
      telefono2: json["cliTel2"]?.toString(),
      email: json["cliCorr"] ?? "",
      direccion: json["cliDir"],
      fechaUltimoPedido: json["cliFecReg"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apellido": apellido,
        "telefono": telefono,
        "telefono2": telefono2,
        "email": email,
        "avatar": avatar,
        "fechaUltimoPedido": fechaUltimoPedido,
        "direccion": direccion,
      };

  Cliente copyWith({
    String? id,
    String? nombre,
    String? apellido,
    String? telefono,
    String? telefono2,
    String? email,
    String? avatar,
    String? fechaUltimoPedido,
    String? direccion,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      telefono: telefono ?? this.telefono,
      telefono2: telefono2 ?? this.telefono2,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      fechaUltimoPedido: fechaUltimoPedido ?? this.fechaUltimoPedido,
      direccion: direccion ?? this.direccion,
    );
  }
}
