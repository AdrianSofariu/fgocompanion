import 'package:fgocompanion/components/mybutton.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application.
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// this is the main page of the application
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // this is the app bar on top
      appBar: AppBar(
        title: const Text(
          "FGO Companion",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      // this is the body of the application
      body: Center(
        child: Container(
          color: const Color(0xFF2a3439),
          // this is the list view with buttons
          child: ListView(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.03),
            scrollDirection: Axis.vertical,
            children: [
              // this is the text on top of the buttons
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  'Welcome to FGO Companion!\n\n For now only the servants page is available. Other features will come in the future.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              // this is the container with the button stack
              Container(
                padding: const EdgeInsets.all(20),
                color: const Color(0xFF2a3439),
                // this is the stack with the buttons
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // this is the button for the servants page
                    MyButton(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              //TODO Create Servant List Page
                              return const Text('Hello World');
                            },
                          ),
                        );
                      },
                      text: "Servants",
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
