// Modelo de Usuario. Mapea los campos del backend (usuId, usuNom, usuApe, …).
class Usuario {
  final String id;
  final String nombre;
  final String apellido;
  final String email;
  final String rol; // "Atelier Manager" o "Costurera"
  final String? telefono;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.rol,
    this.telefono,
  });

  String get nombreCompleto => '$nombre $apellido';

  // Construye un Usuario desde el JSON del backend.
  factory Usuario.fromBackend(Map<String, dynamic> json) {
    final rolRaw = json["usuRol"];
    final rolStr = rolRaw == 1
        ? "Atelier Manager"
        : rolRaw == 2
            ? "Costurera"
            : "Desconocido";

    return Usuario(
      id: json["usuId"]?.toString() ?? "",
      nombre: json["usuNom"] ?? "",
      apellido: json["usuApe"] ?? "",
      email: json["usuCor"] ?? "",
      rol: rolStr,
      telefono: json["usuTel"]?.toString(),
    );
  }

  // Convierte el Usuario a JSON para enviar al backend.
  Map<String, dynamic> toJson() => {
        "usuId": id,
        "usuNom": nombre,
        "usuApe": apellido,
        "usuCor": email,
        "usuTel": telefono,
        "usuRol": rol == "Atelier Manager" ? 1 : 2,
      };
}
