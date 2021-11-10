import 'dart:io';
import 'dart:ui';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muscuapp/model/day.dart';
import 'package:http/http.dart' as http;
import '../global_state.dart' as global_state;

import 'days_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final titleController = TextEditingController();
  List<String> days = List<String>.empty();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                )
              ],
            )),
      ),
    );
  }
}
