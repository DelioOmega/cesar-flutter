import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/ruta.dart';

class ApiClient {
  static final http.Client _client = http.Client();

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// GET — devuelve body decodificado o null si falla
  static Future<dynamic> get(String path) async {
    try {
      final uri = Uri.parse('${Ruta.baseUrl}$path');
      final res = await _client.get(uri, headers: _headers);
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return jsonDecode(res.body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// POST — devuelve body decodificado o null si falla
  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse('${Ruta.baseUrl}$path');
      final res =
          await _client.post(uri, headers: _headers, body: jsonEncode(body));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return jsonDecode(res.body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// PUT — devuelve body decodificado o null si falla
  static Future<dynamic> put(String path, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse('${Ruta.baseUrl}$path');
      final res =
          await _client.put(uri, headers: _headers, body: jsonEncode(body));
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return jsonDecode(res.body);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// DELETE — devuelve true si exitoso, false si falla
  static Future<bool> delete(String path) async {
    try {
      final uri = Uri.parse('${Ruta.baseUrl}$path');
      final res = await _client.delete(uri, headers: _headers);
      return res.statusCode >= 200 && res.statusCode < 300;
    } catch (_) {
      return false;
    }
  }
}
