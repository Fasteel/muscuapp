import 'package:flutter/material.dart';
import 'package:muscuapp/application/models/workout.dart';
import 'package:muscuapp/infrastructure/services/exercice.dart';
import 'package:muscuapp/presentation/common/toast.dart';

class ExerciceScreen extends StatefulWidget {
  const ExerciceScreen({Key? key, required this.workout}) : super(key: key);

  final Workout workout;

  @override
  _ExerciceScreenState createState() => _ExerciceScreenState();
}

class _ExerciceScreenState extends State<ExerciceScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final pauseDurationController = TextEditingController();
  final setNumberController = TextEditingController();
  final repetitionNumberController = TextEditingController();
  final weightController = TextEditingController();
  final positionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                final response = await ExerciceService.create(
                    titleController.text,
                    int.parse(pauseDurationController.text),
                    int.parse(setNumberController.text),
                    int.parse(repetitionNumberController.text),
                    int.parse(weightController.text),
                    widget.workout.id,
                    int.parse(positionController.text));
                if (response.statusCode != 201) {
                  Toast.fail('Failed to create exercice');
                } else {
                  Toast.success('Exercice created');
                }

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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Title cannot be blank";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: pauseDurationController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Pause duration cannot be blank";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Pause duration',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: setNumberController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Set number cannot be blank";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Set number',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: repetitionNumberController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Repetition number cannot be blank";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Repetition number',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Weight cannot be blank";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Weight',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: positionController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Position cannot be blank";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Position',
                    ),
                  ),
                ],
              )),
        ));
  }
}
