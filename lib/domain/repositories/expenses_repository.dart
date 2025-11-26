import 'package:harcama_app/domain/entities/expenses.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> getExpenses();
  Future<void> addExpense(Expense expense);
  Future<void> deleteExpense(String id);
  Future<void> updateExpense(Expense expense);
}
