import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';

class ThemeNotifier extends ChangeNotifier with WidgetsBindingObserver {
  bool _isDark = false;
  final Box settingsBox;

  ThemeNotifier(this.settingsBox) {
    WidgetsBinding.instance.addObserver(this);
    _loadTheme();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // Always update from system when it changes
    _updateThemeFromSystem();
  }

  void _loadTheme() {
    if (settingsBox.containsKey('isDark')) {
      _isDark = settingsBox.get('isDark', defaultValue: false);
      notifyListeners();
    } else {
      _updateThemeFromSystem();
    }
  }

  void _updateThemeFromSystem() {
    final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    final isSystemDark = brightness == Brightness.dark;
    
    // Update state and save to persist the system change
    if (_isDark != isSystemDark) {
      _isDark = isSystemDark;
      settingsBox.put('isDark', _isDark);
      notifyListeners();
    }
  }

  bool get isDark => _isDark;

  ThemeMode get currentTheme => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDark = !_isDark;
    settingsBox.put('isDark', _isDark);
    notifyListeners();
  }
}
