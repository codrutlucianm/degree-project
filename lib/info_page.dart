import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'About Tremor',
          style: GoogleFonts.lobster(
            fontSize: 30,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16.0),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
              Text(
                  'Tremor was designed to give an insight into suspicious behavior regarding a Parkinson\'s disease symptom, namely hand shakes.',
                  style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 12.0),
              Text(
                  'The app is set by default to run in the foreground, while it is closed.This feature can be disabled in the Settings menu.',
                  style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 12.0),
              Text(
                  'Tremor makes use of the accelerometer that the device is equipped with in order to record activity which resembles hand shakes.'
                  'You can learn more about how the accelerometer works in the Live sensor data menu',
                  style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 12.0),
              Text(
                  'The dashboard displays the date and time of the recorded handshakes.',
                  style: TextStyle(fontSize: 16.0)),
            ],
          ),
        ),
      ),
    );
  }
}
