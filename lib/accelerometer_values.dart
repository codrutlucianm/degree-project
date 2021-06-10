import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkinson_detection_app/info_page.dart';
import 'package:parkinson_detection_app/settings_page.dart';
import 'package:sensors/sensors.dart';

class AccelerometerValues extends StatefulWidget {
  @override
  AccelerometerValuesState createState() => AccelerometerValuesState();
}

class AccelerometerValuesState extends State<AccelerometerValues> {
  List<double> _accelerometerValues = <double>[0, 0, 0];
  final List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];
  final List<Widget> pages = <Widget>[
    AccelerometerValues(),
    SettingsPage(),
    InfoPage(),
  ];

  @override
  void initState() {
    super.initState();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues = <double>[event.x, event.y, event.z];
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Live sensor data',
          style: GoogleFonts.lobster(
            fontSize: 30,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 16.0),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Current accelerometer values:',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16.0),
                height: 50,
                width: 350,
                color: Theme.of(context).accentColor.withOpacity(0.5),
                child: Align(
                  alignment: Alignment.center,
                  child: Text('x: ' +
                      _accelerometerValues.elementAt(0).toStringAsFixed(1)),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16.0),
                height: 50,
                width: 350,
                color: Theme.of(context).accentColor.withOpacity(0.5),
                child: Align(
                  alignment: Alignment.center,
                  child: Text('y: ' +
                      _accelerometerValues.elementAt(1).toStringAsFixed(1)),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16.0),
                height: 50,
                width: 350,
                color: Theme.of(context).accentColor.withOpacity(0.5),
                child: Align(
                  alignment: Alignment.center,
                  child: Text('z: ' +
                      _accelerometerValues.elementAt(2).toStringAsFixed(1)),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16.0),
                child: const Text(
                    'The information displayed by the accelerometer of your device indicates if the device is moving in a particular direction.'),
              ),
              Expanded(
                child: Image.asset(
                  Theme.of(context).accentColor == Colors.purple[200]
                      ? 'assets/axis_dark.jpg'
                      : 'assets/axis_light.png',
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
