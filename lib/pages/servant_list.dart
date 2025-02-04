// This file contains the ServantList widget, which displays a list of all servants in the game.
import 'package:fgocompanion/pages/servant_details.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServantList extends StatefulWidget {
  const ServantList({super.key});

  @override
  State<ServantList> createState() => _ServantListState();
}

class _ServantListState extends State<ServantList> {
  List<dynamic> servantList = [];
  Map<String, bool> classMap = {
    'Saber': true,
    'Archer': true,
    'Lancer': true,
    'Rider': true,
    'Caster': true,
    'Assassin': true,
    'Berserker': true,
    'Ruler': true,
    'Avenger': true,
    'Alter Ego': true,
    'Moon Cancer': true,
    'Foreigner': true,
    'Shielder': true,
    'Pretender': true,
    'Beast': true,
  };

  //Add a controller for the search bar
  final TextEditingController filter = TextEditingController();

  //Add a variable for the filtered list
  List<dynamic> filteredServantList = [];

  @override
  void initState() {
    super.initState();
    fetchServantData();
    filter.addListener(searchListener);
  }

  /// Fetches servant data from the Atlas Academy API.
  ///
  /// This function sends a GET request to the Atlas Academy API and retrieves
  /// a list of servants. If the request is successful (HTTP status code 200),
  /// it decodes the JSON response and updates the `servantList` state.
  /// If the request fails, it throws an exception.
  Future<void> fetchServantData() async {
    final response = await http.get(Uri.parse(
        'https://api.atlasacademy.io/export/NA/basic_servant.json'
        /*'https://api.atlasacademy.io/export/JP/basic_servant_lang_en.json'*/));
    if (response.statusCode == 200) {
      setState(() {
        servantList = json.decode(utf8.decode(response.bodyBytes));
        filteredServantList = servantList;
      });
    } else {
      throw Exception('Failed to fetch servant data');
    }
  }

  /// Updates the filtered servant list based on the search text.
  ///
  /// This function is called whenever the text in the search bar changes.
  /// If the search bar is empty, it sets `filteredServantList` to the original `servantList`.
  /// If the search bar is not empty, it filters `servantList` to include only the servants
  /// whose names contain the search text (case-insensitive), and sets this filtered list to `filteredServantList`.
  void searchListener() {
    if (filter.text.isEmpty) {
      setState(() {
        filteredServantList = servantList;
      });
    } else {
      setState(() {
        filteredServantList = servantList
            .where((servant) => servant['name']
                .toLowerCase()
                .contains(filter.text.toLowerCase()))
            .toList();
      });
    }
  }

  void selectClass(String className) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servants'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        color: const Color(0xFF2a3439),
        // B
        child: Column(
          children: [
            //search textfield
            TextField(
              style: const TextStyle(color: Colors.white),
              controller: filter,
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                hintText: 'Search...',
                hintStyle: TextStyle(color: Color(0xFFFFFFFF)),
              ),
            ),
            //filter by class using ToggleButtons
            //page content
            Expanded(
              child: filteredServantList.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredServantList.length,
                      itemBuilder: (context, index) {
                        final servant = filteredServantList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ServantDetails(
                                    servantId: servant['collectionNo']),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5.0,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            color: const Color(0xFF87CEFA),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(servant['face']),
                              ),
                              title: Text(
                                servant['name'],
                                style:
                                    const TextStyle(color: Color(0xFF000000)),
                              ),
                              subtitle: Text(
                                'Collection No: ${servant['collectionNo']}',
                                style:
                                    const TextStyle(color: Color(0xFFFFFFFF)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
