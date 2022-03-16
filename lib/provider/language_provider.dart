import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartrr/generated/l10n.dart';

class LanguageNotifier extends ChangeNotifier {
  String key = "locale";
  SharedPreferences _pref;

  String _locale = "en";

  String get locale => _locale;

  LanguageNotifier() {
    _locale = "en";
    _loadFromPrefs();
  }

  _initPrefs() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
  }

  changeLanguage(String languageCode) {
    S.load(Locale(languageCode));
    _locale = languageCode;
    _saveToPrefs();
    notifyListeners();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _locale = _pref.getString(key) ?? "en";
    S.load(Locale(_locale));
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _pref.setString(key, _locale);
  }
}
