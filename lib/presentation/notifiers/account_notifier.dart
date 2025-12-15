import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/account.dart';
import 'package:harcama_app/domain/usecases/account/add_account.dart';
import 'package:harcama_app/domain/usecases/account/delete_account.dart';
import 'package:harcama_app/domain/usecases/account/get_account.dart';
import 'package:harcama_app/domain/usecases/account/update_account.dart';

class AccountNotifier extends ChangeNotifier{
  final AddAccount addAccount;
  final DeleteAccount deleteAccount;
  final GetAccount getAccounts;
  final UpdateAccount updateAccount;

  AccountNotifier({
    required this.getAccounts,
    required this.addAccount,
    required this.updateAccount,
    required this.deleteAccount,
  }){
    fetchAccounts();
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Account> _accounts = [];
  List<Account> get accounts => _accounts;

  Future<void> fetchAccounts() async {
    _setLoading(true);
    try {
      _accounts = await getAccounts();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Hata: İşlemler yüklenirken bir aksilik oldu: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addNewAccount(Account account) async {
    _setLoading(true);
    try {
      await addAccount(account);
      await fetchAccounts();
    } catch (e) {
      _errorMessage = 'Hata: İşlem eklenemedi: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateExistingAccount(Account account) async {
    _setLoading(true);
    try {
      await updateAccount(account);
      await fetchAccounts();
    } catch (e) {
      _errorMessage = 'Hata: İşlem güncellenemedi: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteExistingAccount(String id) async {
    _setLoading(true);
    try {
      await deleteAccount(id);
      await fetchAccounts();
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



