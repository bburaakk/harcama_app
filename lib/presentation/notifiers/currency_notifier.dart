import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CurrencyNotifier extends ChangeNotifier {
  String _currencyCode = 'TRY';
  String _currencySymbol = '₺';
  final Box settingsBox;

  CurrencyNotifier(this.settingsBox) {
    _loadCurrency();
  }

  String get currencyCode => _currencyCode;
  String get currencySymbol => _currencySymbol;

  void _loadCurrency() {
    _currencyCode = settingsBox.get('currencyCode', defaultValue: 'TRY');
    _updateSymbol();
    notifyListeners();
  }

  Future<void> setCurrency(String code) async {
    if (_currencyCode != code) {
      _currencyCode = code;
      _updateSymbol();
      notifyListeners();
      await settingsBox.put('currencyCode', code);
    }
  }

  void _updateSymbol() {
    switch (_currencyCode) {
      case 'TRY':
        _currencySymbol = '₺';
        break;
      case 'USD':
        _currencySymbol = '\$';
        break;
      case 'EUR':
        _currencySymbol = '€';
        break;
      case 'GBP':
        _currencySymbol = '£';
        break;
      default:
        _currencySymbol = '₺';
    }
  }
}
