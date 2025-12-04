import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/domain/usecases/transaction/add_transaction.dart';
import 'package:harcama_app/domain/usecases/transaction/delete_transaction.dart';
import 'package:harcama_app/domain/usecases/transaction/get_transactions.dart';
import 'package:harcama_app/domain/usecases/transaction/update_transaction.dart';

class TransactionNotifier extends ChangeNotifier{
  final AddTransaction addTransaction;
  final DeleteTransaction deleteTransaction;
  final GetTransactions getTransactions;
  final UpdateTransaction updateTransaction;

  TransactionNotifier({
    required this.getTransactions,
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
  }){
    fetchTransactions();
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Transaction> _transactions = [];
  List<Transaction> get transactions => _transactions;

  Future<void> fetchTransactions() async {
    _setLoading(true);
    try {
      _transactions = await getTransactions();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Hata: İşlemler yüklenirken bir aksilik oldu: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addNewTransaction(Transaction transaction) async {
    _setLoading(true);
    try {
      await addTransaction(transaction);
      await fetchTransactions();
    } catch (e) {
      _errorMessage = 'Hata: İşlem eklenemedi: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateExistingTransaction(Transaction transaction) async {
    _setLoading(true);
    try {
      await updateTransaction(transaction);
      await fetchTransactions();
    } catch (e) {
      _errorMessage = 'Hata: İşlem güncellenemedi: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteExistingTransaction(String id) async {
    _setLoading(true);
    try {
      await deleteTransaction(id);
      await fetchTransactions();
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



