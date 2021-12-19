import 'package:flutter/material.dart';

class WorkoutTitleInput extends StatelessWidget {
  const WorkoutTitleInput({Key? key, required this.titleController})
      : super(key: key);

  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: titleController,
      validator: (value) => value!.isEmpty ? "Title cannot be blank" : null,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Title',
      ),
    );
  }
}
