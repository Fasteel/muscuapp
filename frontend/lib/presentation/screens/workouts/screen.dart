import 'package:flutter/material.dart';
import 'package:muscuapp/application/helpers/day.dart';
import 'package:muscuapp/application/models/workout.dart';
import 'package:muscuapp/infrastructure/services/workout.dart';
import 'package:muscuapp/presentation/screens/workout/screen.dart';

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
                itemCount: snapshot.data!.length,
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
                    subtitle: Text(DayHelper.getFormattedDays(workout.days)),
                  ));
                });
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
