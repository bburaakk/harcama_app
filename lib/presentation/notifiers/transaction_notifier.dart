import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/category.dart';
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

  Category? getMostExpensiveCategoryByDate(int targetMonth, int targetYear) {
    final filteredList = _transactions.where((t) {
      return t.date.month == targetMonth &&
          t.date.year == targetYear &&
          t.type == TransactionType.expense &&
          t.category != null;
    }).toList();

    if (filteredList.isEmpty) return null;
    final Map<String, double> categoryTotals = {};
    final Map<String, Category> categoryObjects = {};

    for (var t in filteredList) {
      final catId = t.category!.id;

      categoryTotals[catId] = (categoryTotals[catId] ?? 0) + t.amount;

      categoryObjects.putIfAbsent(catId, () => t.category!);
    }

    if (categoryTotals.isEmpty) return null;

    final topEntry = categoryTotals.entries.reduce((a, b) => a.value > b.value ? a : b);

    return categoryObjects[topEntry.key];
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

}



