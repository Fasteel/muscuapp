import 'dart:convert';
import 'dart:io';

import '../global_state.dart' as global_state;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:muscuapp/factories/workout.dart';

class Workouts extends StatelessWidget {
  const Workouts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WorkoutList(),
    );
  }
}

class WorkoutList extends StatefulWidget {
  const WorkoutList({Key? key}) : super(key: key);

  @override
  _WorkoutListState createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {
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
    return FutureBuilder<List<Workout>>(
        future: _workouts,
        builder: (BuildContext context, AsyncSnapshot<List<Workout>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                  child: ListTile(
                title: Text(snapshot.data![index].title),
                subtitle: Text(
                    snapshot.data![index].days.map((e) => e.key).join(', ')),
              ));
            },
            itemCount: snapshot.data!.length,
          );
        });
  }
}
