import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parkinson_detection_app/foreground_provider.dart';
import 'package:parkinson_detection_app/theme_provider.dart';
import 'package:provider/provider.dart';

import 'dashboard.dart';
import 'home_page.dart';

Future<void> main() async {
  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<dynamic>>[
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<ForegroundProvider>(
          create: (_) => ForegroundProvider(),
        ),
      ],
      child: Tremor(),
    ),
  );
  //maybeStartFGS();
}

dynamic maybeStartFGS() async {
  if (!(await ForegroundService.foregroundServiceIsStarted())) {
    await ForegroundService.setServiceIntervalSeconds(5);

    await ForegroundService.notification.startEditMode();

    await ForegroundService.notification.setTitle('Tremor');
    await ForegroundService.notification
        .setText('Tremor is running in the foreground');

    await ForegroundService.notification.finishEditMode();

    await ForegroundService.startForegroundService(getValues);
    await ForegroundService.getWakeLock();
    await ForegroundService.setupIsolateCommunication((dynamic message) {
      debugPrint('main received: $message');
    });
  }
}

dynamic toggleForegroundServiceOnOff() async {
  final bool fgsIsRunning =
      await ForegroundService.foregroundServiceIsStarted();

  if (fgsIsRunning) {
    await ForegroundService.stopForegroundService();
  } else {
    maybeStartFGS();
  }
}

class Tremor extends StatefulWidget {
  @override
  _TremorState createState() => _TremorState();
}

class _TremorState extends State<Tremor> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
       builder: (BuildContext context, ThemeProvider provider, Widget child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Tremor',
            theme:
                provider.darkTheme ? AppThemes.darkTheme : AppThemes.lightTheme,
            home: AnimatedSplashScreen(
              splash: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Tremor',
                    style: GoogleFonts.lobster(
                        fontSize: 56,
                        color: provider.darkTheme
                            ? Colors.purple[200]
                            : Colors.purple),
                  ),
                ],
              ),
              backgroundColor: provider.darkTheme ? Colors.black : Colors.white,
              nextScreen: HomePage(),
            ),
          );
        },
      ),
    );
  }
}
