import 'package:flutter/material.dart';
import 'dart:async';
import 'package:light/light.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch:
          Colors.teal
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }

}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  int _lighting = 0;
  late Light _light;

  late StreamSubscription _sub;

  // Declare a variable for the current background color
  late Color _backgroundColor;

// Declare a variable for the current text color
  late Color _textColor;

  void onData(int sensor_value) async {
    print("Sensor val: $sensor_value");
    setState(() {
      _lighting = sensor_value;
      // Update the background color and text color based on the light level
      if (sensor_value < 30) {
        // Dark room, use black background and white text
        _backgroundColor = Colors.black;
        _textColor = Colors.white;
      } else if (sensor_value < 100) {
        // Dim room, use gray background and black text
        _backgroundColor = Colors.grey;
        _textColor = Colors.black;
      } else {
        // Bright room, use white background and black text
        _backgroundColor = Colors.white;
        _textColor = Colors.black;
      }
    });
  }

  void startListening() {
    _light = new Light();
    try {
      _sub = _light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startListening();
  }

  void x(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bctx) {
          return Container(
            color:_backgroundColor ,
            height: 200,
            child: Center(
              child: Text(
                'Sensor value: $_lighting\n',
                style: TextStyle(
                    color:_textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.teal,

        title: const Text('Lighting Sensor '),
        actions: [
          Icon(Icons.settings),
        ],
      ),
      body: new Container(
        width: double.infinity,
        height: double.infinity,
        color: _backgroundColor,
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(top: 300),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text('Testing Lighting ',
                    style: TextStyle(
                        color: _textColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: () => x(context),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.teal
                      )
                      ,
                      child: Text("sensor value",style: TextStyle(color: _textColor),)),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  RichText(text: TextSpan(text: 'Created by :\n',
                      style: TextStyle(
                          fontSize: 15,color: _textColor),
                    children: [
                      TextSpan(text: 'Mohamed Ramadan sedky',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: _textColor
                      ))
                    ]

                  )
                  ),

                ],
              ),
            )

          ],
        ),
      ),

    );
  }
}
