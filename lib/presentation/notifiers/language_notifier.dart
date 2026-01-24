import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LanguageNotifier extends ChangeNotifier with WidgetsBindingObserver {
  Locale _currentLocale = const Locale('en');
  final Box settingsBox;

  Locale get currentLocale => _currentLocale;

  LanguageNotifier(this.settingsBox) {
    WidgetsBinding.instance.addObserver(this);
    _loadLocale();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    // Always update from system when it changes, regardless of manual preference
    _updateLocaleFromSystem();
  }

  void _loadLocale() {
    if (settingsBox.containsKey('languageCode')) {
      final languageCode = settingsBox.get('languageCode');
      _currentLocale = Locale(languageCode);
      notifyListeners();
    } else {
      _updateLocaleFromSystem();
    }
  }

  void _updateLocaleFromSystem() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    Locale newLocale;
    // Check if system locale is supported (tr), otherwise default to en
    if (systemLocale.languageCode == 'tr') {
      newLocale = const Locale('tr');
    } else {
      newLocale = const Locale('en');
    }
    
    // Update state and save to persist the system change
    setLocale(newLocale);
  }

  Future<void> setLocale(Locale locale) async {
    if (_currentLocale != locale) {
      _currentLocale = locale;
      notifyListeners();
      await settingsBox.put('languageCode', locale.languageCode);
    }
  }
}
