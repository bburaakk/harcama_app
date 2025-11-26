import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/entities/expenses.dart';
import 'package:harcama_app/domain/repositories/expenses_repository.dart';
import 'package:uuid/uuid.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final List<Expense> _expenses = [];
  var uuid = Uuid();

  @override
  Future<void> addExpense(Expense expense) async {
    final newExpense = Expense(
      id: uuid.v4(),
      title: expense.title,
      amount: expense.amount,
      date: expense.date,
      category: expense.category, 
    );
    _expenses.add(newExpense);
  }

  @override
  Future<List<Expense>> getExpenses() async { // Test için şimdilik dursun
    if (_expenses.isEmpty) {
      _expenses.addAll([
        Expense(
          id: '1',
          title: 'Kahve',
          amount: 15.0,
          date: DateTime.now(),
          category: const Category(id: '1', title: 'Yemek', icon: '🍔'),
        ),
        Expense(
          id: '2',
          title: 'Kitap',
          amount: 45.0,
          date: DateTime.now().subtract(const Duration(days: 1)),
          category: const Category(id: '2', title: 'Eğitim', icon: '📚'),
        ),
      ]);
    }
    return List.from(_expenses);
  }

  @override
  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((expense) => expense.id == id);
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
    }
  }
}