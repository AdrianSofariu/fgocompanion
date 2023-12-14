import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

class ServantDetails extends StatefulWidget {
  // this is the servant id which is used in the API call
  final int servantId;

  const ServantDetails({Key? key, required this.servantId}) : super(key: key);

  @override
  State<ServantDetails> createState() => _ServantDetailsState();
}

class _ServantDetailsState extends State<ServantDetails> {
  dynamic servant;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servant Details'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(2.0),
          color: const Color(0xFF2a3439),
          child: servant == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(1.0),
                      color: Colors.blue[900],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
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
                    CarouselSlider(
                      items: [
                        ...servant['extraAssets']['charaGraph']['ascension']
                            .values,
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
                      ),
                    ),
                  ],
                )),
    );
  }
}
