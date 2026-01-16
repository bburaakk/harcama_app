import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeNotifier extends ChangeNotifier with WidgetsBindingObserver {
  bool _isDark = false;

  ThemeNotifier() {
    WidgetsBinding.instance.addObserver(this);
    _updateThemeFromSystem();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    _updateThemeFromSystem();
  }

  void _updateThemeFromSystem() {
    final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    final isSystemDark = brightness == Brightness.dark;
    if (_isDark != isSystemDark) {
      _isDark = isSystemDark;
      notifyListeners();
    }
  }

  bool get isDark => _isDark;

  ThemeMode get currentTheme => _isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
