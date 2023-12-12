import 'package:fgocompanion/pages/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FGO Companion',
      theme: ThemeData(
          // This is the theme of the application.
          primarySwatch: Colors.blue,
          fontFamily: 'TitilliumWeb'),
      home: const MyHomePage(title: 'HomePage'),
    );
  }
}
