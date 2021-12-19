class Day {
  int id;
  String key;

  Day({required this.id, required this.key});

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      id: json["id"],
      key: json["key"],
    );
  }
}
