import 'package:harcama_app/domain/entities/expenses.dart';
import 'package:harcama_app/domain/repositories/expenses_repository.dart';

class GetExpenses {
  final ExpenseRepository repository;

  GetExpenses(this.repository);

  Future<List<Expense>> call() async {
    return await repository.getExpenses();
  }
}
