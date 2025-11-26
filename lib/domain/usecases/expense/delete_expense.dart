import 'package:harcama_app/domain/repositories/expenses_repository.dart';

class DeleteExpense {
  final ExpenseRepository repository;

  DeleteExpense(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteExpense(id);
  }
}
