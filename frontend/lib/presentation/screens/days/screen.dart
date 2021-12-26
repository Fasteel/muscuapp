import 'package:flutter/material.dart';
import 'package:muscuapp/application/helpers/day.dart';
import 'package:muscuapp/application/models/day.dart';
import 'package:muscuapp/infrastructure/services/day.dart';

class DaysScreen extends StatefulWidget {
  const DaysScreen({Key? key, required this.days}) : super(key: key);

  final List<Day> days;

  @override
  _DaysScreenState createState() => _DaysScreenState();
}

class _DaysScreenState extends State<DaysScreen> {
  List<Day> selectedDays = [];
  late Future<List<Day>> _days;

  @override
  void initState() {
    super.initState();
    selectedDays = List.from(widget.days);
    _days = DayService.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder<List<Day>>(
              future: _days,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Day>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(36.0),
                        child: CircularProgressIndicator(),
                      )
                    ],
                  ));
                }

                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var exercice = snapshot.data![index];

                    return Card(
                        child: ListTile(
                      onTap: () {
                        setState(() {
                          if (selectedDays.contains(exercice)) {
                            selectedDays.remove(exercice);
                          } else {
                            selectedDays.add(exercice);
                          }
                        });
                      },
                      trailing: selectedDays
                              .any((element) => element.key == exercice.key)
                          ? const Icon(Icons.check_box_outlined,
                              color: Colors.blue)
                          : const Icon(Icons.check_box_outline_blank),
                      title: Text(DayHelper.getTranslation(exercice.key)),
                    ));
                  },
                );
              })
        ],
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
