import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../l10n/app_localizations.dart';

class LanguageProvider with ChangeNotifier {
  static const String _languageKey = 'language_code';
  late SharedPreferences _prefs;
  Locale _currentLocale = const Locale('en');

  LanguageProvider() {
    _loadLanguage();
  }

  Locale get currentLocale => _currentLocale;

  Future<void> _loadLanguage() async {
    try {
      debugPrint('Loading saved language preference');
      _prefs = await SharedPreferences.getInstance();
      final savedLanguage = _prefs.getString(_languageKey);
      if (savedLanguage != null) {
        debugPrint('Found saved language: $savedLanguage');
        _currentLocale = Locale(savedLanguage);
        notifyListeners();
      } else {
        debugPrint('No saved language found, using default: en');
      }
    } catch (e) {
      debugPrint('Error loading language preference: $e');
    }
  }

  Future<void> setLanguage(String languageCode) async {
    try {
      debugPrint('Setting language to: $languageCode');
      _currentLocale = Locale(languageCode);
      await _prefs.setString(_languageKey, languageCode);
      // Force a rebuild of the entire app
      notifyListeners();
      // Add a small delay to ensure the UI updates
      await Future.delayed(const Duration(milliseconds: 100));
      notifyListeners();
    } catch (e) {
      debugPrint('Error setting language: $e');
    }
  }

  static List<Locale> get supportedLocales => const [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('fr'), // French
        Locale('de'), // German
        Locale('it'), // Italian
        Locale('pt'), // Portuguese
        Locale('ru'), // Russian
        Locale('zh'), // Chinese
        Locale('ja'), // Japanese
        Locale('ko'), // Korean
      ];

  static List<LocalizationsDelegate> get localizationsDelegates => [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];
} 