import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkinson_detection_app/theme_provider.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _toggled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  ),
                  onChanged: (bool value) {
                    provider.toggleTheme();
                  },
                  value: provider.darkTheme,
                  activeColor: Colors.purple[200],
                );
              },
            ),
            SwitchListTile(
                title: const Text('Foreground Process'),
                onChanged: (bool value) {
                  toggleForegroundServiceOnOff();
                  setState(() {
                    _toggled = !value;
                  });
                },
                value: !_toggled,
              activeColor: Colors.purple[200],
            ),
          ],
        ),
      ),
    );
  }
}
