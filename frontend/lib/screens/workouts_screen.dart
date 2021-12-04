import 'dart:convert';
import 'dart:io';

import 'package:muscuapp/model/day.dart';
import '../global_state.dart' as global_state;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muscuapp/model/workout.dart';
import 'package:muscuapp/screens/workout_screen.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({Key? key}) : super(key: key);

  @override
  _WorkoutsScreenState createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  late Future<List<Workout>> _workouts;

  @override
  void initState() {
    super.initState();
    _workouts = getWorkouts();
  }

  Future<List<Workout>> getWorkouts() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/workouts/'),
      headers: {
        HttpHeaders.authorizationHeader: global_state.token,
      },
    );
    if (response.statusCode != 200) {
      return List<Workout>.empty();
    }
    return List<Workout>.from(
        json.decode(response.body).map((data) => Workout.fromJson(data)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Workout>>(
          future: _workouts,
          builder:
              (BuildContext context, AsyncSnapshot<List<Workout>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                var workout = snapshot.data![index];
                return Card(
                    child: ListTile(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WorkoutScreen(workout: workout)),
                    );
                    setState(() {
                      _workouts = getWorkouts();
                    });
                  },
                  title: Text(workout.title),
                  subtitle: Text(workout.days
                      .map((day) => Day.getTranslation(day.key))
                      .join(', ')),
                ));
              },
              itemCount: snapshot.data!.length,
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WorkoutScreen()),
            );
            setState(() {
              _workouts = getWorkouts();
            });
          },
          child: const Icon(Icons.add)),
    );
  }
}
