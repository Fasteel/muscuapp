import 'dart:io';
import 'dart:ui';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muscuapp/model/day.dart';
import 'package:http/http.dart' as http;
import 'package:muscuapp/model/exercice.dart';
import 'package:muscuapp/model/workout.dart';
import '../global_state.dart' as global_state;

import 'days_screen.dart';

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
  late Future<List<Exercice>> _exercices;

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      titleController.text = widget.workout!.title;
      days = widget.workout!.days.map((e) => e.key).toList();
      _exercices = getExercices();
    }
  }

  Future<List<Exercice>> getExercices() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/exercices/?workout=' +
          widget.workout!.id.toString()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                var i = 0;
                var daysPK =
                    translations.keys.fold<List<int>>([], (value, element) {
                  i++;
                  if (days.contains(element)) {
                    value.add(i);
                  }

                  return value;
                });

                if (widget.workout == null) {
                  final response = await http.post(
                      Uri.parse('http://127.0.0.1:8000/workouts/'),
                      headers: {
                        HttpHeaders.authorizationHeader: global_state.token,
                        HttpHeaders.contentTypeHeader: 'application/json'
                      },
                      body: jsonEncode({
                        "title": titleController.text,
                        "state": "AC",
                        "days": daysPK
                      }));
                  if (response.statusCode != 201) {
                    Fluttertoast.showToast(
                        msg: 'Failed to create workout',
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.red,
                        fontSize: 18.0);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Workout created',
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.green,
                        fontSize: 18.0);
                  }
                } else {
                  final response = await http.put(
                      Uri.parse('http://127.0.0.1:8000/workouts/' +
                          widget.workout!.id.toString()),
                      headers: {
                        HttpHeaders.authorizationHeader: global_state.token,
                        HttpHeaders.contentTypeHeader: 'application/json'
                      },
                      body: jsonEncode({
                        "title": titleController.text,
                        "state": "AC",
                        "days": daysPK
                      }));
                  if (response.statusCode != 200) {
                    Fluttertoast.showToast(
                        msg: 'Failed to update workout',
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.red,
                        fontSize: 18.0);
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Workout updated',
                        gravity: ToastGravity.TOP,
                        backgroundColor: Colors.green,
                        fontSize: 18.0);
                  }
                }

                Navigator.pop(context);
              }
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
                FutureBuilder(
                    future: _exercices,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Exercice>> snapshot) {
                      if (widget.workout == null) {
                        return const Text("");
                      }

                      if (widget.workout != null && !snapshot.hasData) {
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
