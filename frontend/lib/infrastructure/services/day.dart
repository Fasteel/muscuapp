import 'dart:convert';

import 'package:http/http.dart';
import 'package:muscuapp/application/models/day.dart';
import 'package:muscuapp/infrastructure/constants.dart' as constants;
import 'package:muscuapp/infrastructure/http.dart';

class DayService {
  static String endpoint = 'days/';

  static Future<List<Day>> fetchAll() async {
    final response = await get(
      Uri.parse(constants.baseUrl + endpoint),
      headers: getDefaultHeader(),
    );
    if (response.statusCode != 200) {
      return List<Day>.empty();
    }
    return List<Day>.from(
        json.decode(response.body).map((data) => Day.fromJson(data)));
  }
}
