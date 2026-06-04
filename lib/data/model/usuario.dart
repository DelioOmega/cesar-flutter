class Usuario {
  final int id;
  final String nombres;
  final String apellidos;
  final String correo;
  final String genero;
  final String rol;

  Usuario({
    required this.id, required this.nombres,  required this.apellidos,
    required this.correo, required this.genero, required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json["USU_ID"] is int ? json["USU_ID"] : int.parse(json["USU_ID"]),
      nombres: json["USU_NOMBRES"],
      apellidos: json["USU_APELLIDOS"],
      correo: json["USU_CORREO"],
      genero: json["USU_GENERO"],
      rol: json["USU_ROL"],
    );
  }
}