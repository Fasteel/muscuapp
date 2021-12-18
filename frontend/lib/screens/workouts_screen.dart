import 'package:muscuapp/model/day.dart';
import 'package:muscuapp/services/workout_service.dart';
import 'package:flutter/material.dart';
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
    _workouts = WorkoutService.fetchAll();
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
                      _workouts = WorkoutService.fetchAll();
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
              _workouts = WorkoutService.fetchAll();
            });
          },
          child: const Icon(Icons.add)),
    );
  }
}
