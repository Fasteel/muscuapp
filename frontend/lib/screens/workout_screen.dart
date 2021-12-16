import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:muscuapp/model/day.dart';
import 'package:http/http.dart' as http;
import 'package:muscuapp/model/exercice.dart';
import 'package:muscuapp/model/workout.dart';
import '../global_state.dart' as global_state;

import 'days_screen.dart';
import 'exercice_screen.dart';

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
      _exercices = getExercices();
    } else {
      _exercices = null;
    }
  }

  Future<Workout> getWorkout(int id) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/workouts/' + id.toString()),
      headers: {
        HttpHeaders.authorizationHeader: global_state.token,
      },
    );
    return Workout.fromJson(json.decode(response.body));
  }

  Future<List<Exercice>> getExercices() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/exercices/?workout=' +
          _workout!.id.toString()),
      headers: {
        HttpHeaders.authorizationHeader: global_state.token,
      },
    );
    if (response.statusCode != 200) {
      return List<Exercice>.empty();
    }
    return List<Exercice>.from(
        json.decode(response.body).map((data) => Exercice.fromJson(data)));
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
      res = await http.post(Uri.parse('http://127.0.0.1:8000/workouts/'),
          headers: {
            HttpHeaders.authorizationHeader: global_state.token,
            HttpHeaders.contentTypeHeader: 'application/json'
          },
          body: jsonEncode(
              {"title": titleController.text, "state": "AC", "days": daysPK}));
    } else {
      res = await http.put(
          Uri.parse(
              'http://127.0.0.1:8000/workouts/' + _workout!.id.toString()),
          headers: {
            HttpHeaders.authorizationHeader: global_state.token,
            HttpHeaders.contentTypeHeader: 'application/json'
          },
          body: jsonEncode(
              {"title": titleController.text, "state": "AC", "days": daysPK}));
    }

    if (res.statusCode != 201) {
      Fluttertoast.showToast(
          msg: 'Failed to create workout',
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.red,
          fontSize: 18.0);
      return null;
    }

    Fluttertoast.showToast(
        msg: 'Workout created',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        fontSize: 18.0);
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
                TextFormField(
                  controller: titleController,
                  validator: (value) =>
                      value!.isEmpty ? "Title cannot be blank" : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DaysScreen(days: days)),
                    );

                    setState(() {
                      if (result != null) {
                        days = result;
                      }
                    });
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
                                : days
                                    .map((day) => Day.getTranslation(day))
                                    .join(' - '),
                            style: const TextStyle(fontSize: 15.0),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
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
                              subTitle: exercice.setNumber.toString() +
                                  " x " +
                                  exercice.repetitionNumber.toString() +
                                  " rep",
                              rightLabel:
                                  exercice.pauseDuration.toString() + " sec");
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

            var workout = await getWorkout(workoutId);
            setState(() {
              _workout = workout;
            });

            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExerciceScreen(workout: workout)),
            );

            setState(() {
              _exercices = getExercices();
            });
          },
          child: const Icon(Icons.add)),
    );
  }
}

class ExerciceCard extends StatelessWidget {
  const ExerciceCard(
      {Key? key, this.title = "", this.subTitle = "", this.rightLabel = ""})
      : super(key: key);

  final String title;
  final String subTitle;
  final String rightLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(title),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(subTitle,
                      style: TextStyle(color: Colors.grey.shade600)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text(rightLabel, style: TextStyle(color: Colors.grey.shade600)),
          ),
        ],
      ),
    );
  }
}
