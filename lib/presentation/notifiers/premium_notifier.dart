import 'package:flutter/material.dart';

class PremiumNotifier extends ChangeNotifier {
  bool _isPremium = false;

  bool get isPremium => _isPremium;

  void activatePremium() {
    _isPremium = true;
    notifyListeners();
  }

  void deactivatePremium() {
    _isPremium = false;
    notifyListeners();
  }
}
