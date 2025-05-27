import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(context, AppLocalizations);
    if (localizations == null) {
      debugPrint('Warning: AppLocalizations not found in context');
      return AppLocalizations(const Locale('en'));
    }
    return localizations;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'appTitle': 'Business Finder',
      'search': 'Search',
      'settings': 'Settings',
      'profile': 'Profile',
      'language': 'Language',
      'selectLanguage': 'Select Language',
      'save': 'Save',
      'cancel': 'Cancel',
      'edit': 'Edit',
      'name': 'Name',
      'phone': 'Phone',
      'email': 'Email',
      'address': 'Address',
      'rating': 'Rating',
      'reviews': 'Reviews',
      'open': 'Open',
      'closed': 'Closed',
      'call': 'Call',
      'website': 'Website',
      'directions': 'Get Directions',
      'noResults': 'No results found',
      'error': 'Error',
      'success': 'Success',
      'loading': 'Loading...',
      'appPreferences': 'App Preferences',
      'arSettings': 'AR Settings',
      'about': 'About',
    },
    'es': {
      'appTitle': 'Buscador de Negocios',
      'search': 'Buscar',
      'settings': 'Configuración',
      'profile': 'Perfil',
      'language': 'Idioma',
      'selectLanguage': 'Seleccionar Idioma',
      'save': 'Guardar',
      'cancel': 'Cancelar',
      'edit': 'Editar',
      'name': 'Nombre',
      'phone': 'Teléfono',
      'email': 'Correo',
      'address': 'Dirección',
      'rating': 'Calificación',
      'reviews': 'Reseñas',
      'open': 'Abierto',
      'closed': 'Cerrado',
      'call': 'Llamar',
      'website': 'Sitio Web',
      'directions': 'Obtener Direcciones',
      'noResults': 'No se encontraron resultados',
      'error': 'Error',
      'success': 'Éxito',
      'loading': 'Cargando...',
      'appPreferences': 'Preferencias de la App',
      'arSettings': 'Configuración AR',
      'about': 'Acerca de',
    },
    // Add more languages here...
  };

  String _getLocalizedString(String key) {
    try {
      debugPrint('Getting translation for key: $key in locale: ${locale.languageCode}');
      final translations = _localizedValues[locale.languageCode] ?? _localizedValues['en']!;
      final value = translations[key];
      if (value == null) {
        debugPrint('Warning: No translation found for key: $key in locale: ${locale.languageCode}');
        return key;
      }
      return value;
    } catch (e) {
      debugPrint('Error getting translation for key: $key - $e');
      return key;
    }
  }

  String get appTitle => _getLocalizedString('appTitle');
  String get search => _getLocalizedString('search');
  String get settings => _getLocalizedString('settings');
  String get profile => _getLocalizedString('profile');
  String get language => _getLocalizedString('language');
  String get selectLanguage => _getLocalizedString('selectLanguage');
  String get save => _getLocalizedString('save');
  String get cancel => _getLocalizedString('cancel');
  String get edit => _getLocalizedString('edit');
  String get name => _getLocalizedString('name');
  String get phone => _getLocalizedString('phone');
  String get email => _getLocalizedString('email');
  String get address => _getLocalizedString('address');
  String get rating => _getLocalizedString('rating');
  String get reviews => _getLocalizedString('reviews');
  String get open => _getLocalizedString('open');
  String get closed => _getLocalizedString('closed');
  String get call => _getLocalizedString('call');
  String get website => _getLocalizedString('website');
  String get directions => _getLocalizedString('directions');
  String get noResults => _getLocalizedString('noResults');
  String get error => _getLocalizedString('error');
  String get success => _getLocalizedString('success');
  String get loading => _getLocalizedString('loading');
  String get appPreferences => _getLocalizedString('appPreferences');
  String get arSettings => _getLocalizedString('arSettings');
  String get about => _getLocalizedString('about');
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    debugPrint('Checking if locale is supported: ${locale.languageCode}');
    return ['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    debugPrint('Loading translations for locale: ${locale.languageCode}');
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
} 