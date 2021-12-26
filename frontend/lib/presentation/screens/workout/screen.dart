import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:muscuapp/application/helpers/day.dart';
import 'package:muscuapp/application/helpers/exercice.dart';
import 'package:muscuapp/application/models/exercice.dart';
import 'package:muscuapp/application/models/workout.dart';
import 'package:muscuapp/infrastructure/services/exercice.dart';
import 'package:muscuapp/infrastructure/services/workout.dart';
import 'package:muscuapp/presentation/screens/exercice/screen.dart';
import 'package:muscuapp/presentation/common/toast.dart';

import 'widgets/exercice_card.dart';
import 'widgets/workout_title_input.dart';
import 'widgets/workout_day_selector.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key, this.workout}) : super(key: key);

  final Workout? workout;

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final titleController = TextEditingController();
  List<String> days = List<String>.empty();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Exercice>>? _exercices;
  Workout? _workout;

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      _workout = widget.workout;
      titleController.text = _workout!.title;
      days = _workout!.days.map((e) => e.key).toList();
      _exercices = ExerciceService.fetchAll(_workout);
    } else {
      _exercices = null;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future<int?> saveWorkout() async {
    if (!_formKey.currentState!.validate()) {
      return null;
    }

    var i = 0;
    var daysPK = translations.keys.fold<List<int>>([], (value, element) {
      i++;
      if (days.contains(element)) {
        value.add(i);
      }

      return value;
    });

    Response res;

    if (_workout == null) {
      res = await WorkoutService.create(titleController.text, daysPK);
    } else {
      res = await WorkoutService.update(
          _workout!.id, titleController.text, daysPK);
    }

    if (res.statusCode != 201 && res.statusCode != 200) {
      Toast.fail('Failed to create workout');
      return null;
    }

    Toast.success('Workout created');

    return jsonDecode(res.body)['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              await saveWorkout();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                WorkoutTitleInput(titleController: titleController),
                const SizedBox(height: 20),
                WorkoutDaySelector(
                    days: days,
                    onDaysSelected: (selectedDays) {
                      setState(() {
                        if (selectedDays != null) {
                          days = selectedDays;
                        }
                      });
                    }),
                const SizedBox(height: 20),
                FutureBuilder<List<Exercice>>(
                    future: _exercices,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Exercice>> snapshot) {
                      if (_workout == null) {
                        return const Text("");
                      }

                      if (_workout != null && !snapshot.hasData) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        );
                      }

                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var exercice = snapshot.data![index];

                          return ExerciceCard(
                              title: exercice.title,
                              subTitle:
                                  "${ExerciceHelper.formatSetNumber(exercice)} ${ExerciceHelper.formatRepetitionNumber(exercice)}",
                              rightLabel:
                                  ExerciceHelper.formatDuration(exercice));
                        },
                      );
                    })
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var workoutId = await saveWorkout();
            if (workoutId == null) {
              return;
            }

            var workout = await WorkoutService.fetch(workoutId);
            setState(() {
              _workout = workout;
            });

            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExerciceScreen(workout: workout)),
            );

            setState(() {
              _exercices = ExerciceService.fetchAll(_workout);
            });
          },
          child: const Icon(Icons.add)),
    );
  }
}
