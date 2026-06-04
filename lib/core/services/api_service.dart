import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  static Future<http.Response> get(String url) {
    return http.get(Uri.parse(url), headers: headers);
  }

  static Future<http.Response> post(String url, Map<String, dynamic> body) {
    return http.post(Uri.parse(url), body: json.encode(body), headers: headers);
  }

  static Future<http.Response> put(String url, Map<String, dynamic> body) {
    return http.put(Uri.parse(url), body: json.encode(body), headers: headers);
  }

  static Future<http.Response> delete(String url) {
    return http.delete(Uri.parse(url), headers: headers);
  }
}
