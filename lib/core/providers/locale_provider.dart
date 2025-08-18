import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  
  Locale _locale = const Locale('en', 'US');
  
  Locale get locale => _locale;
  
  LocaleProvider() {
    _loadLocale();
  }
  
  void setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, '${locale.languageCode}_${locale.countryCode}');
  }
  
  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeString = prefs.getString(_localeKey);
    
    if (localeString != null) {
      final parts = localeString.split('_');
      if (parts.length == 2) {
        _locale = Locale(parts[0], parts[1]);
        notifyListeners();
      }
    }
  }
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('ps', 'AF'), // Pashto
    Locale('fa', 'AF'), // Dari
  ];
  
  // Language names for UI
  static const Map<String, String> languageNames = {
    'en_US': 'English',
    'ps_AF': 'پښتو', // Pashto
    'fa_AF': 'دری', // Dari
  };
  
  String getLanguageName(Locale locale) {
    final key = '${locale.languageCode}_${locale.countryCode}';
    return languageNames[key] ?? locale.languageCode;
  }
  
  bool isRTL() {
    return _locale.languageCode == 'ps' || _locale.languageCode == 'fa';
  }
}
