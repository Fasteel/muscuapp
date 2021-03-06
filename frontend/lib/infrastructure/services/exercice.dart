import 'dart:convert';

import 'package:http/http.dart';
import 'package:muscuapp/application/models/exercice.dart';
import 'package:muscuapp/application/models/workout.dart';
import 'package:muscuapp/infrastructure/http.dart';
import 'package:muscuapp/infrastructure/constants.dart' as constants;

class ExerciceService {
  static String endpoint = 'exercices/';

  static Future<List<Exercice>> fetchAll(Workout? workout) async {
    final response = await get(
      Uri.parse(
          constants.baseUrl + endpoint + '?workout=' + workout!.id.toString()),
      headers: getDefaultHeader(),
    );
    if (response.statusCode != 200) {
      return List<Exercice>.empty();
    }
    return List<Exercice>.from(
        json.decode(response.body).map((data) => Exercice.fromJson(data)));
  }

  static Future<Response> create(Exercice exercice) {
    return post(Uri.parse(constants.baseUrl + endpoint),
        headers: getDefaultHeader(), body: exercice.toJson());
  }
}
