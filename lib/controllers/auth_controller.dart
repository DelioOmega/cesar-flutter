import 'package:flutter/foundation.dart';
import '../core/services/auth_service.dart';
import '../data/model/usuario.dart';

class AuthController extends ChangeNotifier {
  Usuario? _usuario;
  bool _loading = false;
  String? _error;

  Usuario? get usuario => _usuario;
  bool get loading => _loading;
  bool get isLoggedIn => _usuario != null;
  String? get error => _error;

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

  Future<String> recuperarPassword(String email) async {
    return AuthService.recuperarPassword(email);
  }

  void logout() {
    _usuario = null;
    _error = null;
    notifyListeners();
  }
}
