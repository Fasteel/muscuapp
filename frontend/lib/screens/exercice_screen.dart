import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:muscuapp/model/workout.dart';
import 'package:muscuapp/services/exercice_service.dart';

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
                  Fluttertoast.showToast(
                      msg: 'Failed to create exercice',
                      gravity: ToastGravity.TOP,
                      backgroundColor: Colors.red,
                      fontSize: 18.0);
                } else {
                  Fluttertoast.showToast(
                      msg: 'Exercice created',
                      gravity: ToastGravity.TOP,
                      backgroundColor: Colors.green,
                      fontSize: 18.0);
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
