import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors/sensors.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

List<double> _accelerometerValues = <double>[0, 0, 0];
List<double> _previousAccelerometerValues = <double>[-999, -999, -999];
int _counter = 0;
final List<List<double>> _logs = <List<double>>[];
final List<StreamSubscription<dynamic>> _streamSubscriptions =
<StreamSubscription<dynamic>>[];

void getValues() {
  _streamSubscriptions
      .add(accelerometerEvents.listen((AccelerometerEvent event) {
    _accelerometerValues = <double>[
      double.parse(event.x.toStringAsFixed(1)),
      double.parse(event.y.toStringAsFixed(1)),
      double.parse(event.z.toStringAsFixed(1))
    ];
    if (_previousAccelerometerValues != <double>[-999, -999, -999] &&
        _accelerometerValues.elementAt(0) -
            _previousAccelerometerValues.elementAt(0).abs() >=
            0.1 &&
        _accelerometerValues.elementAt(0) -
            _previousAccelerometerValues.elementAt(0).abs() <=
            3.5 &&
        _accelerometerValues.elementAt(1) -
            _previousAccelerometerValues.elementAt(1).abs() >=
            0.7 &&
        _accelerometerValues.elementAt(1) -
            _previousAccelerometerValues.elementAt(1).abs() <=
            8.5 &&
        _accelerometerValues.elementAt(2) -
            _previousAccelerometerValues.elementAt(2).abs() >=
            0.9 &&
        _accelerometerValues.elementAt(2) -
            _previousAccelerometerValues.elementAt(2).abs() <=
            5) {
      debugPrint('fmm');
    }
    _logs.add(_accelerometerValues);
    _previousAccelerometerValues = _accelerometerValues;
  }));
}

class DashboardState extends State<Dashboard> {

  @override
  void initState() {
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Dashboard',
          style: GoogleFonts.lobster(
            fontSize: 30,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 16.0, top: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Logged activity:',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text(_counter.toString()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
