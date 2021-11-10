const translations = {
  "MON": "Monday",
  "TUE": "Tuesday",
  "WED": "Wednesday",
  "THU": "Thursday",
  "FRI": "Friday",
  "SAT": "Saturday",
  "SUN": "Sunday"
};

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

  static getTranslation(String key) {
    return translations[key];
  }
}
