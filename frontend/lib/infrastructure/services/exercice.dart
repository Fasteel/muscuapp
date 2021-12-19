import 'dart:convert';

import 'package:http/http.dart';
import 'package:muscuapp/application/models/exercice.dart';
import 'package:muscuapp/application/models/workout.dart';
import 'package:muscuapp/infrastructure/http.dart';

class ExerciceService {
  static Future<List<Exercice>> fetchAll(Workout? workout) async {
    final response = await get(
      Uri.parse(
          'http://127.0.0.1:8000/exercices/?workout=' + workout!.id.toString()),
      headers: getDefaultHeader(),
    );
    if (response.statusCode != 200) {
      return List<Exercice>.empty();
    }
    return List<Exercice>.from(
        json.decode(response.body).map((data) => Exercice.fromJson(data)));
  }

  static Future<Response> create(String title, int pauseDuration, int setNumber,
      int repetitionNumber, int weight, int workoutId, int position) {
    return post(Uri.parse('http://127.0.0.1:8000/exercices/'),
        headers: getDefaultHeader(),
        body: jsonEncode({
          "title": title,
          "pause_duration": pauseDuration,
          "set_number": setNumber,
          "repetition_number": repetitionNumber,
          "weight": weight,
          "workout": workoutId,
          "position": position
        }));
  }
}
