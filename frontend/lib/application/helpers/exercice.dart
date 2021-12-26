import 'package:muscuapp/application/models/exercice.dart';

class ExerciceHelper {
  static String formatSetNumber(Exercice exercice) {
    return "${exercice.setNumber.toString()} x";
  }

  static String formatRepetitionNumber(Exercice exercice) {
    return "${exercice.repetitionNumber.toString()} rep";
  }

  static String formatDuration(Exercice exercice) {
    return "${exercice.pauseDuration.toString()} sec";
  }
}
