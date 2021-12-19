import 'package:muscuapp/application/models/day.dart';

const translations = {
  "MON": "Monday",
  "TUE": "Tuesday",
  "WED": "Wednesday",
  "THU": "Thursday",
  "FRI": "Friday",
  "SAT": "Saturday",
  "SUN": "Sunday"
};

class DayHelper {
  static getFormattedDaysFromKeyDays(List<String> keys) {
    return keys.map((key) => getTranslation(key)).join(' - ');
  }

  static getFormattedDays(List<Day> days) {
    return days.map((day) => getTranslation(day.key)).join(', ');
  }

  static getTranslation(String key) {
    return translations[key];
  }
}
