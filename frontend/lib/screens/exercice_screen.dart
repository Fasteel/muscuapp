import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExerciceScreen extends StatefulWidget {
  const ExerciceScreen({Key? key}) : super(key: key);

  @override
  _ExerciceScreenState createState() => _ExerciceScreenState();
}

class _ExerciceScreenState extends State<ExerciceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: const Text("Exercice")); // TODO Create exercice form
    // TODO Send the form to the backend
  }
}
