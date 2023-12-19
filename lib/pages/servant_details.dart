import 'dart:convert';

import 'package:fgocompanion/components/mytrow.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

import '../components/skill.dart';

class ServantDetails extends StatefulWidget {
  // this is the servant id which is used in the API call
  final int servantId;

  const ServantDetails({Key? key, required this.servantId}) : super(key: key);

  @override
  State<ServantDetails> createState() => _ServantDetailsState();
}

class _ServantDetailsState extends State<ServantDetails> {
  dynamic servant;
  String activeImageKey = '';
  List<dynamic> traits = [];
  String traitString = '';

  // card counts
  int quickCount = 0;
  int artsCount = 0;
  int busterCount = 0;

  // fetch servant data from the API when the widget is created
  @override
  void initState() {
    super.initState();
    fetchServantData();
  }

  /// Fetches servant data from the Atlas Academy API.
  /// This method sends a GET request to the Atlas Academy API and retrieves
  /// the data for a specific servant. The servant ID is provided by the `widget.servantId`.
  /// After the data is fetched, it is decoded from JSON and set to the `servant` variable.
  /// If the HTTP request fails, this method throws an exception.
  /// This method is asynchronous and returns a `Future<void>`.
  Future<void> fetchServantData() async {
    final response = await http.get(Uri.parse(
        'https://api.atlasacademy.io/nice/JP/servant/${widget.servantId}?lang=en'));
    if (response.statusCode == 200) {
      setState(() {
        servant = json.decode(utf8.decode(response.bodyBytes));
        precacheServantImages();
        getCardCounts();
        onCarouselPageChanged(0, CarouselPageChangedReason.controller);
      });
    } else {
      throw Exception('Failed to fetch servant data');
    }
  }

  /// Pre-caches the servant images.
  /// This method pre-caches the images for a servant's ascension and costume (if available).
  /// The image URLs are taken from the `servant` variable, which should be set before this method is called.
  /// The images are pre-cached using the `precacheImage` function, which loads the images into memory
  /// so they can be displayed immediately when needed.
  /// This method does not return a value.
  void precacheServantImages() {
    for (var url in servant['extraAssets']['charaGraph']['ascension'].values) {
      precacheImage(NetworkImage(url), context);
    }
    if (servant['extraAssets']['charaGraph'].containsKey('costume') &&
        servant['extraAssets']['charaGraph']['costume'].isNotEmpty) {
      for (var url in servant['extraAssets']['charaGraph']['costume'].values) {
        precacheImage(NetworkImage(url), context);
      }
    }
  }

  /// Function: getCardCounts
  ///
  /// This function iterates over the 'cards' array in the 'servant' object.
  /// It increments the count of 'quick', 'arts', and 'buster' cards based on the card type found in the array.
  ///
  /// The 'servant' object is expected to have a 'cards' key with an array value.
  /// The array should contain strings that represent the type of card, which can be 'quick', 'arts', or 'buster'.
  ///
  /// The function modifies the following variables in the outer scope:
  /// - quickCount: An integer that represents the count of 'quick' cards. It is incremented when a 'quick' card is found.
  /// - artsCount: An integer that represents the count of 'arts' cards. It is incremented when an 'arts' card is found.
  /// - busterCount: An integer that represents the count of 'buster' cards. It is incremented when a 'buster' card is found.
  ///
  /// The function does not return a value.
  void getCardCounts() {
    for (var card in servant['cards']) {
      if (card == 'quick') {
        quickCount++;
      } else if (card == 'arts') {
        artsCount++;
      } else if (card == 'buster') {
        busterCount++;
      }
    }
  }

  /// Function: onCarouselPageChanged
  ///
  /// This function is triggered when the page in the CarouselSlider widget changes.
  /// It updates the `activeImageKey` and `traits` based on the new page index.
  ///
  /// If the new index is greater than 3 (indicating it's a costume, not an ascension art),
  /// it sets `activeImageKey` to the key of the costume at `index - 4` in the `servant['extraAssets']['charaGraph']['costume']` map.
  /// It then sets `traits` to the traits of this costume. If the costume doesn't have any traits, it uses the default traits.
  ///
  /// If the new index is 3 or less (indicating it's an ascension art), it sets `traits` to the default traits.
  ///
  /// Finally, it concatenates the trait names into a single string `traitString`.
  ///
  /// This function does not return a value.
  void onCarouselPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      if (index > 3) {
        activeImageKey = servant['extraAssets']['charaGraph']['costume']
            .keys
            .elementAt(index - 4);
        traits =
            servant['ascensionAdd']['individuality']['costume'][activeImageKey];
        if (traits.isEmpty) {
          traits = servant['traits'];
        }
      } else if (index <= 3) {
        if (index == 0) {
          activeImageKey = "0";
        } else {
          activeImageKey = servant['extraAssets']['charaGraph']['ascension']
              .keys
              .elementAt(index);
        }
        if (servant['ascensionAdd']['individuality']['ascension']
                [activeImageKey] !=
            null) {
          traits = servant['ascensionAdd']['individuality']['ascension']
              [activeImageKey];
        }
        if (traits.isEmpty) {
          traits = servant['traits'];
        }
      }

      // Concatenate the trait names into a single string
      traitString = traits.map((trait) => trait['name']).join(', ');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //AppBar at the top of the page
      appBar: AppBar(
        title: const Text('Servant Details'),
        backgroundColor: Colors.blue,
      ),
      // main body of the page
      body: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(2.0),
          color: const Color(0xFF2a3439),
          // inline if to determine if we already have the data
          child: servant == null
              // if not, we display a progress indicator
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              // if yes, we display the scroll view with items
              : SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      // this is the container with charater name,
                      // class id and class icon
                      Container(
                        padding: const EdgeInsets.all(1.0),
                        color: Colors.blue[900],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // fetch class icon based on servant class id
                            // handle special case for Goetia entry in API
                            Row(
                              children: [
                                servant['name'] != 'Goetia'
                                    ? Image.network(
                                        "https://assets.atlasacademy.io/GameData/JP/ClassIcons/class3_${servant['classId']}.png",
                                        scale: 2,
                                      )
                                    : Image.network(
                                        "https://assets.atlasacademy.io/GameData/JP/ClassIcons/class3_21.png",
                                        scale: 2,
                                      ),
                                Text(
                                  " ${servant['name']} ",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "${servant['rarity']}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Icon(Icons.star, color: Colors.yellow[700]),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // this is the ascenison arts carousel
                      CarouselSlider(
                        items: [
                          // get all ascension arts
                          ...servant['extraAssets']['charaGraph']['ascension']
                              .values,
                          // if the servant has costumes fetch them too
                          if (servant['extraAssets']['charaGraph']
                                  .containsKey('costume') &&
                              servant['extraAssets']['charaGraph']['costume']
                                  .isNotEmpty)
                            ...servant['extraAssets']['charaGraph']['costume']
                                .values
                        ].map((url) {
                          return Image.network(
                            url,
                            fit: BoxFit.cover,
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 500,
                          enlargeCenterPage: true,
                          autoPlay: false,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          viewportFraction: 1,
                          onPageChanged: onCarouselPageChanged,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // this is the table with details
                      // max level
                      MyTrow(
                          description: 'Max Level',
                          value: servant['lvMax'].toString()),
                      // attribute
                      MyTrow(
                          description: 'Attribute',
                          value: servant['attribute'].toString()),
                      // gender
                      MyTrow(
                          description: 'Gender',
                          value: servant['gender'].toString()),
                      // traits
                      MyTrow(description: 'Traits', value: traitString //[
                          //for (var traitDict in servant['traits'])
                          //  traitDict['name']
                          //].join(', ')
                          ),
                      // star absorption
                      MyTrow(
                          description: 'Star Absorption',
                          value: servant['starAbsorb'].toString()),
                      // max hp
                      MyTrow(
                          description: 'Max HP',
                          value: servant['hpMax'].toString()),
                      // max attack
                      MyTrow(
                          description: 'Max ATK',
                          value: servant['atkMax'].toString()),
                      Table(
                        border: TableBorder.all(color: Colors.black),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        columnWidths: const {
                          0: FlexColumnWidth(3),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(children: [
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.blue.shade900,
                                child: const Text(
                                  "Cards",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.green,
                                child: Text(
                                  quickCount.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.blue,
                                child: Text(
                                  artsCount.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.red,
                                child: Text(
                                  busterCount.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ...List<Map<String, dynamic>>.from(servant['skills'])
                          .map((skill) => SkillComponent(skill: skill))
                          .toList(),
                    ],
                  ),
                )),
    );
  }
}
