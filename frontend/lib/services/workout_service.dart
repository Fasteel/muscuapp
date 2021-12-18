import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:muscuapp/model/workout.dart';
import 'package:http/http.dart' as http;
import '../global_state.dart' as global_state;

class WorkoutService {
  static Future<List<Workout>> fetchAll() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/workouts/'),
      headers: {
        HttpHeaders.authorizationHeader: global_state.token,
      },
    );
    if (response.statusCode != 200) {
      return List<Workout>.empty();
    }
    return List<Workout>.from(
        json.decode(response.body).map((data) => Workout.fromJson(data)));
  }

  static Future<Workout> fetch(int id) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/workouts/' + id.toString()),
      headers: {
        HttpHeaders.authorizationHeader: global_state.token,
      },
    );
    return Workout.fromJson(json.decode(response.body));
  }

  static Future<Response> create(String title, List<int> daysPK) {
    return http.post(Uri.parse('http://127.0.0.1:8000/workouts/'),
        headers: {
          HttpHeaders.authorizationHeader: global_state.token,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode({"title": title, "state": "AC", "days": daysPK}));
  }

  static Future<Response> update(int id, String title, List<int> daysPK) {
    return http.put(
        Uri.parse('http://127.0.0.1:8000/workouts/' + id.toString()),
        headers: {
          HttpHeaders.authorizationHeader: global_state.token,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonEncode({"title": title, "state": "AC", "days": daysPK}));
  }
}
