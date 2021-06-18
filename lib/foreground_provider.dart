import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForegroundProvider extends ChangeNotifier {
  ForegroundProvider() {
    _foregroundOn = true;
    _loadFromPreferences();
  }

  final String key = 'foreground';
  SharedPreferences _preferences;
  bool _foregroundOn;

  bool get foregroundOn => _foregroundOn;

  void toggleFGS() {
    _foregroundOn = !_foregroundOn;
    _saveToPreferences();
    notifyListeners();
  }

  Future<void> _initPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> _loadFromPreferences() async {
    await _initPreferences();
    _foregroundOn = _preferences.getBool(key) ?? true;
    notifyListeners();
  }

  Future<void> _saveToPreferences() async {
    await _initPreferences();
    _preferences.setBool(key, _foregroundOn);
  }
}

