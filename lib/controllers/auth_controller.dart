import 'package:flutter/foundation.dart';
import '../core/services/auth_service.dart';
import '../data/model/usuario.dart';

// Controlador de autenticación. Maneja el estado del usuario logueado.
// Se provee globalmente via ChangeNotifierProvider en main.dart.
class AuthController extends ChangeNotifier {
  Usuario? _usuario;
  bool _loading = false;
  String? _error;

  Usuario? get usuario => _usuario;
  bool get loading => _loading;
  bool get isLoggedIn => _usuario != null;
  String? get error => _error;

  // Llama a AuthService.login y actualiza el estado.
  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final user = await AuthService.login(email, password);
    if (user != null) {
      _usuario = user;
      _loading = false;
      notifyListeners();
      return true;
    } else {
      _error = "Credenciales incorrectas";
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // Simula el envío de enlace de recuperación (no llama al backend).
  Future<String> recuperarPassword(String email) async {
    return AuthService.recuperarPassword(email);
  }

  // Cierra sesión: limpia el usuario y notifica.
  void logout() {
    _usuario = null;
    _error = null;
    notifyListeners();
  }
}
