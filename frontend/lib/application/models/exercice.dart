import 'dart:convert';

class Exercice {
  int? id;
  String title;
  int pauseDuration;
  int setNumber;
  int repetitionNumber;
  int weight;
  int? workout;
  int? position;

  Exercice(
      {this.id,
      required this.title,
      required this.pauseDuration,
      required this.setNumber,
      required this.repetitionNumber,
      required this.weight,
      this.workout,
      this.position});

  factory Exercice.fromJson(Map<String, dynamic> res) {
    return Exercice(
      id: res["id"],
      title: res["title"],
      pauseDuration: res["pause_duration"],
      setNumber: res["set_number"],
      repetitionNumber: res["repetition_number"],
      weight: res["weight"],
      workout: res["workout"],
      position: res["position"],
    );
  }

  String toJson() {
    return jsonEncode({
      "title": title,
      "pause_duration": pauseDuration,
      "set_number": setNumber,
      "repetition_number": repetitionNumber,
      "weight": weight,
      "workout": workout,
      "position": position
    });
  }
}
