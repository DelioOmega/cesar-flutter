import 'package:http/http.dart' as http;

class ApiService {
  static Map<String, String> headers = {
    'Authorization': '123456789',
  };

  static Future<http.Response> get(String url) {
    return http.get(Uri.parse(url), headers: headers);
  }

  static Future<http.Response> post(String url, Map body) {
    return http.post(Uri.parse(url), body: body, headers: headers);
  }

  static Future<http.Response> delete(String url) {
    return http.delete(Uri.parse(url), headers: headers);
  }
}