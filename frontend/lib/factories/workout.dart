import 'package:muscuapp/factories/day.dart';

class Workout {
  int id;
  String title;
  String state;
  int user;
  List<Day> days;

  Workout(
      {required this.id,
      required this.title,
      required this.state,
      required this.user,
      required this.days});

  factory Workout.fromJson(Map<String, dynamic> res) {
    List<Day> days =
        List<Day>.from(res["days"].map((data) => Day.fromJson(data)));

    return Workout(
      id: res["id"],
      title: res["title"],
      state: res["state"],
      user: res["user"],
      days: days,
    );
  }
}
