class Exercice {
  int id;
  String title;
  int pauseDuration;
  int setNumber;
  int repetitionNumber;
  int weight;

  Exercice({
    required this.id,
    required this.title,
    required this.pauseDuration,
    required this.setNumber,
    required this.repetitionNumber,
    required this.weight,
  });

  factory Exercice.fromJson(Map<String, dynamic> res) {
    return Exercice(
      id: res["id"],
      title: res["title"],
      pauseDuration: res["pause_duration"],
      setNumber: res["set_number"],
      repetitionNumber: res["repetition_number"],
      weight: res["weight"],
    );
  }
}
