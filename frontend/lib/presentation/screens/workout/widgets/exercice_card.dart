import 'package:flutter/material.dart';

class ExerciceCard extends StatelessWidget {
  const ExerciceCard(
      {Key? key, this.title = "", this.subTitle = "", this.rightLabel = ""})
      : super(key: key);

  final String title;
  final String subTitle;
  final String rightLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(title),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(subTitle,
                      style: TextStyle(color: Colors.grey.shade600)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text(rightLabel, style: TextStyle(color: Colors.grey.shade600)),
          ),
        ],
      ),
    );
  }
}
