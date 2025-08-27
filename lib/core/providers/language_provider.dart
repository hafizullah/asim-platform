import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', '');
  
  Locale get locale => _locale;
  
  void setLanguage(String languageCode) {
    _locale = Locale(languageCode, '');
    notifyListeners();
  }
  
  String get currentLanguage {
    switch (_locale.languageCode) {
      case 'en':
        return 'English';
      case 'fa':
        return 'دری';
      case 'ps':
        return 'پښتو';
      default:
        return 'English';
    }
  }
}
