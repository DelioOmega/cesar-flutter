class Usuario {
  final String nombre;
  final String rol;
  final String email;
  final String? avatar;

  Usuario({
    required this.nombre,
    required this.rol,
    required this.email,
    this.avatar,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombre: json["nombre"] ?? "",
      rol: json["rol"] ?? "",
      email: json["email"] ?? "",
      avatar: json["avatar"],
    );
  }

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "rol": rol,
        "email": email,
        "avatar": avatar,
      };
}
