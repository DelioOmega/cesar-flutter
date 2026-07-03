import '../../data/model/usuario.dart';
import 'api_client.dart';

/// Servicio de autenticación de usuarios.
class AuthService {
  /// Inicia sesión con [email] y [password].
  ///
  /// Endpoint: `GET /usuarios/`
  ///
  /// Obtiene todos los usuarios del backend y busca uno cuyo
  /// `usuCor` coincida con [email] y `usuPassHash` con [password].
  /// Retorna un [Usuario] si hay coincidencia, o `null` si no.
  static Future<Usuario?> login(String email, String password) async {
    final data = await ApiClient.get('/usuarios');
    if (data == null || data is! List) return null;

    for (final u in data) {
      if (u['usuCor'] == email && u['usuPassHash'] == password) {
        return Usuario.fromBackend(Map<String, dynamic>.from(u));
      }
    }
    return null;
  }

  /// Simula el envío de un enlace de recuperación al [email].
  /// No hace llamada real al backend.
  static Future<String> recuperarPassword(String email) async {
    return "Se ha enviado un enlace a $email";
  }
}
