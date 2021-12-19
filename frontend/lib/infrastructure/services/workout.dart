import 'dart:convert';

import 'package:http/http.dart';
import 'package:muscuapp/application/models/workout.dart';
import 'package:muscuapp/infrastructure/http.dart';

class WorkoutService {
  static Future<List<Workout>> fetchAll() async {
    final response = await get(
      Uri.parse('http://127.0.0.1:8000/workouts/'),
      headers: getDefaultHeader(),
    );
    if (response.statusCode != 200) {
      return List<Workout>.empty();
    }
    return List<Workout>.from(
        json.decode(response.body).map((data) => Workout.fromJson(data)));
  }

  static Future<Workout> fetch(int id) async {
    final response = await get(
      Uri.parse('http://127.0.0.1:8000/workouts/' + id.toString()),
      headers: getDefaultHeader(),
    );
    return Workout.fromJson(json.decode(response.body));
  }

  static Future<Response> create(String title, List<int> daysPK) {
    return post(Uri.parse('http://127.0.0.1:8000/workouts/'),
        headers: getDefaultHeader(),
        body: jsonEncode({"title": title, "state": "AC", "days": daysPK}));
  }

  static Future<Response> update(int id, String title, List<int> daysPK) {
    return put(Uri.parse('http://127.0.0.1:8000/workouts/' + id.toString()),
        headers: getDefaultHeader(),
        body: jsonEncode({"title": title, "state": "AC", "days": daysPK}));
  }
}
