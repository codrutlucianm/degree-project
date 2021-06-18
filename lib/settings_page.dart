import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkinson_detection_app/foreground_provider.dart';
import 'package:parkinson_detection_app/main.dart';
import 'package:parkinson_detection_app/theme_provider.dart';
import 'package:parkinson_detection_app/tremors_database.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.lobster(
            fontSize: 30,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Consumer<ThemeProvider>(
              builder:
                  (BuildContext context, ThemeProvider provider, Widget child) {
                return SwitchListTile(
                  title: Text(
                      'Enable ' +
                          (provider.darkTheme ? 'light mode' : 'dark mode'),
                      style: const TextStyle(fontSize: 16.0)),
                  onChanged: (bool value) {
                    provider.toggleTheme();
                  },
                  value: provider.darkTheme,
                  activeColor: Colors.purple[200],
                );
              },
            ),
            Consumer<ForegroundProvider>(
              builder: (BuildContext context, ForegroundProvider provider,
                  Widget child) {
                return SwitchListTile(
                  title: const Text('Allow app to run in the foreground',
                      style: TextStyle(fontSize: 16.0)),
                  onChanged: (bool value) {
                    provider.toggleFGS();
                    toggleForegroundServiceOnOff();
                  },
                  value: provider.foregroundOn,
                  activeColor: Colors.purple[200],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      child: Text('Clear all logs',
                          style: TextStyle(fontSize: 16.0,
                          color: Theme.of(context).accentColor == Colors.purple ? Colors.red : Colors.red[900])),
                    ),
                    onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Do you want to delete all logged tremors?',
                            style: TextStyle(
                                color: Theme.of(context).accentColor)),
                        content: const Text(
                            'All logged tremors will be permanently removed. Do you want to proceed?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: Text('No',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor)),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context, 'Yes');
                              await TremorsDatabase.instance.clearAllTremors();
                            },
                            child: Text('Yes',
                                style: TextStyle(
                                    color: Theme.of(context).accentColor)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
