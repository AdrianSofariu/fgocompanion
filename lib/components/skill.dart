import 'package:flutter/material.dart';

//widget used to display an individual skill of a servant
class SkillComponent extends StatelessWidget {
  final Map<String, dynamic> skill;

  const SkillComponent({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(skill['icon']),
                const SizedBox(width: 8.0),
                Expanded(
                    child: Text(skill['name'],
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(skill['detail'],
                style: const TextStyle(fontSize: 16.0),),
            const SizedBox(height: 16.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 4,
                columns: List<DataColumn>.generate(
                    11, (index) => index != 0 ? DataColumn(label: Text('Lvl $index')) : DataColumn(label: Text(''))),
                rows: [
                  ...skill['functions'].map<DataRow>((function) {
                    return DataRow(
                      cells: [DataCell(Text(function['funcPopupText']))] +
                        function['svals']
                          .map<DataCell>((sval) =>
                              DataCell(Text(sval['Value'].toString())))
                          .toList(),
                    );
                  }).toList(),
                  DataRow(
                    cells: [DataCell(Text(""))] + skill['coolDown']
                        .map<DataCell>(
                            (cooldown) => DataCell(Text(cooldown.toString())))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
