import 'dart:convert';

import 'day.dart';

class Workout {
  int? id;
  String title;
  String state;
  List<Day> days;

  Workout(
      {this.id, required this.title, required this.state, required this.days});

  factory Workout.fromJson(Map<String, dynamic> res) {
    List<Day> days =
        List<Day>.from(res["days"].map((data) => Day.fromJson(data)));

    return Workout(
      id: res["id"],
      title: res["title"],
      state: res["state"],
      days: days,
    );
  }

  toJson() {
    return jsonEncode({
      "title": title,
      "state": "AC",
      "days": days.map((d) => d.id).toList()
    });
  }
}
