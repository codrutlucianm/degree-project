import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _darkTheme = true;
    _loadFromPreferences();
  }

  final String key = 'theme';
  late SharedPreferences _preferences;
  late bool _darkTheme;

  bool get darkTheme => _darkTheme;

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPreferences();
    notifyListeners();
  }

  Future<void> _initPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> _loadFromPreferences() async {
    await _initPreferences();
    _darkTheme = _preferences.getBool(key) ?? true;
    notifyListeners();
  }

  Future<void> _saveToPreferences() async {
    await _initPreferences();
    _preferences.setBool(key, _darkTheme);
  }
}

class AppThemes {
  AppThemes._();

  static ThemeData darkTheme = ThemeData(
    backgroundColor: Colors.black,
    accentColor: Colors.purple[200],
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.black,
    colorScheme: const ColorScheme.dark(),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.black,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    backgroundColor: Colors.white,
    accentColor: Colors.purple,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.light(),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.white,
    ),
  );
}
