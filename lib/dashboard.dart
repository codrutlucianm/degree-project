import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkinson_detection_app/tremor.dart';
import 'package:parkinson_detection_app/tremors_database.dart';
import 'package:sensors/sensors.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

List<double> _accelerometerValues = <double>[0, 0, 0];
List<double> _previousAccelerometerValues = <double>[-999, -999, -999];
final List<StreamSubscription<dynamic>> _streamSubscriptions =
    <StreamSubscription<dynamic>>[];
int counter = 0;
DateTime selectDate;

Future<void> addTremor() async {
  final Tremor tremor = Tremor(recordedDateTime: DateTime.now());

  await TremorsDatabase.instance.create(tremor);
}

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
      counter = counter + 1;
      if (counter >= 3) {
        addTremor();
        counter = 0;
      }
    }
    _previousAccelerometerValues = _accelerometerValues;
  }));
}

class DashboardState extends State<Dashboard> {
  List<Tremor> tremors = <Tremor>[];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getValues();
    refreshTremors();
  }

  Future<void> getTremorsByDate(DateTime date) async {
    tremors = await TremorsDatabase.instance.selectTremorsByDate(date);
    setState(() {});
  }

  Future<void> refreshTremors() async {
    setState(() => isLoading = true);

    tremors = await TremorsDatabase.instance.readAllTremors();

    setState(() => isLoading = false);
  }

  String count = 'all';
  DateTime selectDate;

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Number of logs to be displayed: ',
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    DropdownButton<String>(
                      value: count,
                      icon: const Icon(Icons.arrow_circle_down),
                      iconSize: 20,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Theme.of(context).accentColor,
                      ),
                      onChanged: (String newCount) {
                        setState(() {
                          count = newCount;
                        });
                      },
                      items: <String>['all', '1', '10', '50', '100']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.date_range,
                          color: Theme.of(context).accentColor),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 5),
                          lastDate: DateTime.now(),
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: Theme.of(context).accentColor ==
                                      Colors.purple
                                  ? ThemeData.light().copyWith(
                                      colorScheme:
                                          const ColorScheme.light().copyWith(
                                        primary: Theme.of(context).accentColor,
                                      ),
                                    )
                                  : ThemeData.dark().copyWith(
                                      colorScheme:
                                          const ColorScheme.dark().copyWith(
                                        primary: Theme.of(context).accentColor,
                                        surface: Theme.of(context).accentColor,
                                      ),
                                    ),
                              child: child,
                            );
                          },
                        ).then((DateTime date) => getTremorsByDate(date));
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                  color: Theme.of(context).accentColor,
                  thickness: 5.0,
                  height: 20.0,
                  endIndent: 16.0),
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
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: Text(DateFormat('MMMM d, yyyy - HH:mm')
                            .format(tremors.elementAt(index).recordedDateTime)
                            .toString()));
                  },
                  itemCount:
                      count == 'all' || int.tryParse(count) > tremors.length
                          ? tremors.length
                          : int.tryParse(count),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
