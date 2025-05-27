import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const String _darkModeKey = 'dark_mode';
  static const String _notificationsKey = 'notifications';
  static const String _showDistanceKey = 'show_distance';
  static const String _autoFilterKey = 'auto_filter';
  static const String _maxDistanceKey = 'max_distance';
  static const String _languageKey = 'language';

  late SharedPreferences _prefs;
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _showDistance = true;
  bool _autoFilter = true;
  double _maxDistance = 5.0; // in kilometers
  String _language = 'English';

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get showDistance => _showDistance;
  bool get autoFilter => _autoFilter;
  double get maxDistance => _maxDistance;
  String get language => _language;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    _notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? true;
    _showDistance = _prefs.getBool('showDistance') ?? true;
    _autoFilter = _prefs.getBool('autoFilter') ?? true;
    _maxDistance = _prefs.getDouble('maxDistance') ?? 5.0;
    _language = _prefs.getString('language') ?? 'English';
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    await _prefs.setBool('notificationsEnabled', _notificationsEnabled);
    notifyListeners();
  }

  Future<void> toggleShowDistance() async {
    _showDistance = !_showDistance;
    await _prefs.setBool('showDistance', _showDistance);
    notifyListeners();
  }

  Future<void> toggleAutoFilter() async {
    _autoFilter = !_autoFilter;
    await _prefs.setBool('autoFilter', _autoFilter);
    notifyListeners();
  }

  Future<void> setMaxDistance(double distance) async {
    _maxDistance = distance;
    await _prefs.setDouble('maxDistance', distance);
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _language = language;
    await _prefs.setString('language', language);
    notifyListeners();
  }
} 