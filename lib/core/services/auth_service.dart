import '../../data/model/usuario.dart';

class AuthService {
  static Future<Usuario?> login(String email, String password) async {
    // Simular llamada de red
    await Future.delayed(const Duration(seconds: 1));

    // Demo: cualquier email con password "123456" inicia sesión
    if (email.isNotEmpty && password == "123456") {
      return Usuario(
        nombre: "Elena Rossi",
        rol: "Atelier Manager",
        email: email,
      );
    }
    return null;
  }

  static Future<String> recuperarPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return "Se ha enviado un enlace a $email";
  }
}
