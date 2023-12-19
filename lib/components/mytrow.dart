import 'package:flutter/material.dart';

class MyTrow extends StatelessWidget {
  final String description;
  final String value;

  const MyTrow({super.key, required this.description, required this.value});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(2)},
      children: [
        TableRow(children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.fill,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.blue.shade900,
              child: Text(
                description,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          TableCell(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: Text(
                value,
                style: TextStyle(color: Colors.blue.shade900, fontSize: 15),
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
