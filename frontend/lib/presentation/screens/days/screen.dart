import 'package:flutter/material.dart';
import 'package:muscuapp/application/helpers/day.dart';

class DaysScreen extends StatefulWidget {
  const DaysScreen({Key? key, required this.days}) : super(key: key);

  final List<String> days;

  @override
  _DaysScreenState createState() => _DaysScreenState();
}

class _DaysScreenState extends State<DaysScreen> {
  List<String> selectedDays = [];

  @override
  void initState() {
    super.initState();
    selectedDays = List.from(widget.days);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: translations.entries
            .map((e) => Card(
                    child: ListTile(
                  onTap: () {
                    setState(() {
                      if (selectedDays.contains(e.key)) {
                        selectedDays.remove(e.key);
                      } else {
                        selectedDays.add(e.key);
                      }
                    });
                  },
                  trailing: selectedDays.contains(e.key)
                      ? const Icon(Icons.check_box_outlined, color: Colors.blue)
                      : const Icon(Icons.check_box_outline_blank),
                  title: Text(e.value),
                )))
            .toList(),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, selectedDays);
            },
          )
        ],
      ),
    );
  }
}
