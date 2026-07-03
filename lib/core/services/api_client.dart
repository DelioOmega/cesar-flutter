import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/ruta.dart';

// Cliente HTTP genérico. Todos los servicios lo usan para llamar al backend.
// Concatena Ruta.baseUrl + path y parsea la respuesta JSON automáticamente.
class ApiClient {
  static final http.Client _client = http.Client();

  // Headers JSON por defecto.
  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // GET → devuelve el body parseado o null si falla.
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

  // POST → envía body JSON, devuelve respuesta parseada o null.
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

  // PUT → envía body JSON, devuelve respuesta parseada o null.
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

  // DELETE → devuelve true si la respuesta fue 2xx, false si falla.
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
