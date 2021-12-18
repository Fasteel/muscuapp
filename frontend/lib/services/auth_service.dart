import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:muscuapp/model/login_response.dart';
import '../global_state.dart' as global_state;

class AuthService {
  static Future<LoginResponse?> login(String username, String password) async {
    final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api-token-auth/'),
        body: {'username': username, 'password': password});
    if (response.statusCode != 200) {
      return null;
    }
    var bytes = utf8.encode(username + ":" + password);
    global_state.token = "Basic " + base64.encode(bytes);
    return LoginResponse.fromJson(jsonDecode(response.body));
  }
}
