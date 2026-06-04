import 'dart:convert';
import '../../core/config/ruta.dart';
import '../../core/services/api_service.dart';
import '../../data/model/usuario.dart';

class UsuarioService {
  static Future<List<Usuario>> getUsuarios() async {
    final r = await ApiService.get("${Ruta.baseUrl}lisUsuario.php");

    if (r.statusCode == 200) {
      final List data = json.decode(r.body);
      return data.map((e) => Usuario.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar usuarios");
    }
  }

  static Future<String> registrar(Map data) async {
    final r = await ApiService.post("${Ruta.baseUrl}regUsuario.php", data);
    final res = json.decode(r.body);
    return res["respuesta"];
  }

  static Future<String> editar(Map data) async {
    final r = await ApiService.post("${Ruta.baseUrl}edtUsuario.php", data);
    final res = json.decode(r.body);
    return res["respuesta"];
  }

  static Future<String> eliminar(int id) async {
    final r = await ApiService.delete("${Ruta.baseUrl}eliUsuario.php?ID=$id");
    final res = json.decode(r.body);
    return res["respuesta"];
  }
}