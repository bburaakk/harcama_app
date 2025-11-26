import 'package:harcama_app/domain/entities/expenses.dart';
import 'package:harcama_app/domain/repositories/expenses_repository.dart';

class UpdateExpense {
  final ExpenseRepository repository;

  UpdateExpense(this.repository);

  Future<void> call(Expense expanse) async {
    return await repository.updateExpense(expanse);
  }
}
