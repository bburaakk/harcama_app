import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/expenses.dart';
import 'package:harcama_app/domain/usecases/expense/add_expense.dart';
import 'package:harcama_app/domain/usecases/expense/delete_expense.dart';
import 'package:harcama_app/domain/usecases/expense/get_expenses.dart';
import 'package:harcama_app/domain/usecases/expense/update_expense.dart';

class ExpenseNotifier extends ChangeNotifier{
  final AddExpense addExpense;
  final DeleteExpense deleteExpense;
  final GetExpenses getExpenses;
  final UpdateExpense updateExpense;

  ExpenseNotifier({
    required this.getExpenses,
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
  }){
    fetchExpenses();
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  Future<void> fetchExpenses() async {
    _setLoading(true);
    try {
      _expenses = await getExpenses();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Fuck!! harcamalar yüklenirken bir aksilik oldu: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addNewExpense(Expense expense) async {
    _setLoading(true);
    try {
      await addExpense(expense);
      await fetchExpenses();
    } catch (e) {
      _errorMessage = 'Fuck!! harcama ekleyemedin dostum: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateExistingExpense(Expense expense) async {
    _setLoading(true);
    try {
      await updateExpense(expense);
      await fetchExpenses();
    } catch (e) {
      _errorMessage = 'Fuck!! harcamaları günceleyemedim bro: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteExistingExpense(String id) async {
    _setLoading(true);
    try {
      await deleteExpense(id);
      await fetchExpenses();
    } catch (e) {
      _errorMessage = 'Fuck!! harcamanı silemedim dostum: $e';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

}