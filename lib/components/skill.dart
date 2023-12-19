import 'package:flutter/material.dart';

class SkillComponent extends StatelessWidget {
  final Map<String, dynamic> skill;

  const SkillComponent({Key? key, required this.skill}) : super(key: key);

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
            ...skill['functions'].map((function) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(function['funcPopupText'],
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  ...function['buffs']
                      .where((buff) {
                        return buff['funcTargetTeam'] == 'player' ||
                            buff['funcTargetTeam'] == 'playerOrEnemy';
                      })
                      .map((buff) => Text(
                          '${buff['name']} (${buff['svals'][0]['turns']} turns, ${buff['svals'][0]['count']} count)'))
                      .toList(),
                ],
              );
            }).toList(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 4,
                columns: List<DataColumn>.generate(
                    10, (index) => DataColumn(label: Text('Lvl ${index + 1}'))),
                rows: [
                  ...skill['functions'].map<DataRow>((function) {
                    return DataRow(
                      cells: function['svals']
                          .map<DataCell>((sval) =>
                              DataCell(Text(sval['Value'].toString())))
                          .toList(),
                    );
                  }).toList(),
                  DataRow(
                    cells: skill['coolDown']
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
