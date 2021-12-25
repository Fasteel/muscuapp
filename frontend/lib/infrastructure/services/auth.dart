import 'dart:convert';

import 'package:http/http.dart';
import 'package:muscuapp/application/models/login_response.dart';
import 'package:muscuapp/application/state.dart' as state;
import 'package:muscuapp/infrastructure/constants.dart' as constants;

class AuthService {
  static String endpoint = 'api-token-auth/';

  static Future<LoginResponse?> login(String username, String password) async {
    final response = await post(Uri.parse(constants.baseUrl + endpoint),
        body: {'username': username, 'password': password});
    if (response.statusCode != 200) {
      return null;
    }
    var bytes = utf8.encode(username + ":" + password);
    state.token = "Basic " + base64.encode(bytes);
    return LoginResponse.fromJson(jsonDecode(response.body));
  }
}
