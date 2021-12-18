import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:muscuapp/model/exercice.dart';
import 'package:http/http.dart' as http;
import 'package:muscuapp/model/workout.dart';
import '../global_state.dart' as global_state;

class ExerciceService {
  static Future<List<Exercice>> fetchExercices(Workout? workout) async {
    final response = await http.get(
      Uri.parse(
          'http://127.0.0.1:8000/exercices/?workout=' + workout!.id.toString()),
      headers: {
        HttpHeaders.authorizationHeader: global_state.token,
      },
    );
    if (response.statusCode != 200) {
      return List<Exercice>.empty();
    }
    return List<Exercice>.from(
        json.decode(response.body).map((data) => Exercice.fromJson(data)));
  }

  static Future<Response> create(String title, int pauseDuration, int setNumber,
      int repetitionNumber, int weight, int workoutId, int position) {
    return http.post(Uri.parse('http://127.0.0.1:8000/exercices/'),
        headers: {
          HttpHeaders.authorizationHeader: global_state.token,
          HttpHeaders.contentTypeHeader: 'application/json'
        },
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
