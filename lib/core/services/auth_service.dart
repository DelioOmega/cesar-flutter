import '../../data/model/usuario.dart';
import 'api_client.dart';

class AuthService {
  static Future<Usuario?> login(String email, String password) async {
    // Llamada real al backend: GET /usuarios/
    final data = await ApiClient.get('/usuarios/');
    if (data == null || data is! List) return null;

    for (final u in data) {
      if (u['usuCor'] == email && u['usuPassHash'] == password) {
        return Usuario.fromBackend(Map<String, dynamic>.from(u));
      }
    }
    return null;
  }

  static Future<String> recuperarPassword(String email) async {
    return "Se ha enviado un enlace a $email";
  }
}
