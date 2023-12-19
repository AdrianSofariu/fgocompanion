import 'package:flutter/material.dart';

class SkillComponent extends StatelessWidget {
  final Map<String, dynamic> skill;

  const SkillComponent({Key? key, required this.skill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(skill['icon']),
        Text(skill['name']),
        ...skill['functions'].map((function) {
          return Text(function['funcPopupText']);
        }).toList(),
        Table(
          border: TableBorder.all(color: Colors.black),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
          },
          children: skill['functions']
              .map((function) {
                return TableRow(children: [
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.blue.shade900,
                      child: Text(
                        function['funcPopupText'],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  ...function['svals'].map((sval) {
                    return TableCell(
                      child: Text(sval['Value'].toString()),
                    );
                  }).toList(),
                ]);
              })
              .toList()
              .cast<TableRow>(),
        ),
      ],
    );
  }
}
