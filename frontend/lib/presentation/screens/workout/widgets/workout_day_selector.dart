import 'package:flutter/material.dart';
import 'package:muscuapp/application/helpers/day.dart';
import 'package:muscuapp/presentation/screens/days/screen.dart';

class WorkoutDaySelector extends StatelessWidget {
  const WorkoutDaySelector(
      {Key? key, required this.days, required this.onDaysSelected})
      : super(key: key);

  final List<String> days;
  final void Function(dynamic) onDaysSelected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DaysScreen(days: days)),
        );

        onDaysSelected(result);
      },
      child: Container(
        alignment: Alignment.center,
        child: SizedBox(
          height: 60.00,
          child: Row(
            children: <Widget>[
              const Icon(Icons.calendar_today),
              const SizedBox(width: 10),
              Flexible(
                  child: Text(
                days.isEmpty
                    ? "Select your workout days"
                    : DayHelper.getFormattedDaysFromKeyDays(days),
                style: const TextStyle(fontSize: 15.0),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
