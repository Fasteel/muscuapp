import 'dart:convert';

import 'package:http/http.dart';
import 'package:muscuapp/application/models/day.dart';
import 'package:muscuapp/application/models/workout.dart';
import 'package:muscuapp/infrastructure/http.dart';
import 'package:muscuapp/infrastructure/constants.dart' as constants;

class WorkoutService {
  static String endpoint = 'workouts/';

  static Future<List<Workout>> fetchAll() async {
    final response = await get(
      Uri.parse(constants.baseUrl + endpoint),
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
      Uri.parse(constants.baseUrl + endpoint + id.toString()),
      headers: getDefaultHeader(),
    );
    return Workout.fromJson(json.decode(response.body));
  }

  static Future<Response> create(Workout workout) {
    return post(Uri.parse(constants.baseUrl + endpoint),
        headers: getDefaultHeader(), body: workout.toJson());
  }

  static Future<Response> update(Workout workout) {
    return put(Uri.parse(constants.baseUrl + endpoint + workout.id.toString()),
        headers: getDefaultHeader(), body: workout.toJson());
  }
}
