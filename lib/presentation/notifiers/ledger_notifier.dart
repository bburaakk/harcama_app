import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/ledger.dart';
import 'package:harcama_app/domain/usecases/ledger/add_ledger.dart';
import 'package:harcama_app/domain/usecases/ledger/delete_ledger.dart';
import 'package:harcama_app/domain/usecases/ledger/get_ledger.dart';
import 'package:harcama_app/domain/usecases/ledger/update_ledger.dart';

class LedgerNotifier extends ChangeNotifier{
  final AddLedger addLedger;
  final DeleteLedger deleteLedger;
  final GetLedger getLedgers;
  final UpdateLedger updateLedger;

  LedgerNotifier({
    required this.getLedgers,
    required this.addLedger,
    required this.updateLedger,
    required this.deleteLedger,
  }){
    fetchLedgers();
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Ledger> _ledgers = [];
  List<Ledger> get ledgers => _ledgers;

  Future<void> fetchLedgers() async {
    _setLoading(true);
    try {
      _ledgers = await getLedgers();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Hata: İşlemler yüklenirken bir aksilik oldu: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addNewLedger(Ledger ledger) async {
    _setLoading(true);
    try {
      await addLedger(ledger);
      await fetchLedgers();
    } catch (e) {
      _errorMessage = 'Hata: İşlem eklenemedi: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateExistingLedger(Ledger ledger) async {
    _setLoading(true);
    try {
      await updateLedger(ledger);
      await fetchLedgers();
    } catch (e) {
      _errorMessage = 'Hata: İşlem güncellenemedi: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteExistingLedger(String id) async {
    _setLoading(true);
    try {
      await deleteLedger(id);
      await fetchLedgers();
    } catch (e) {
      _errorMessage = 'Hata: İşlem silinemedi: $e';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

}



