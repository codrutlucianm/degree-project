import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:parkinson_detection_app/accelerometer_values.dart';
import 'package:parkinson_detection_app/dashboard.dart';
import 'package:parkinson_detection_app/info_page.dart';
import 'package:parkinson_detection_app/settings_page.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _c;
  final List<Widget> pages = <Widget>[
    Dashboard(),
    AccelerometerValues(),
    SettingsPage(),
    InfoPage(),
  ];

  @override
  void initState() {
    _c = PageController(
      initialPage: _currentIndex,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _c,
        children: pages,
        onPageChanged: (int newPage) {
          setState(
            () {
              _currentIndex = newPage;
            },
          );
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 50,
        color: Theme.of(context).accentColor,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        animationCurve: Curves.bounceInOut,
        animationDuration: const Duration(milliseconds: 200),
        items: const <Widget>[
          Icon(Icons.home, size: 20),
          Icon(Icons.open_with, size: 20),
          Icon(Icons.settings_rounded, size: 20),
          Icon(Icons.info, size: 20),
        ],
        onTap: (int index) {
          setState(
            () {
              _currentIndex = index;
            },
          );
          _c.animateToPage(index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        },
      ),
    );
  }
}
