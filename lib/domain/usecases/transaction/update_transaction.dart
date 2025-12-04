import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/domain/repositories/transaction_repository.dart';

class UpdateTransaction {
  final TransactionRepository repository;

  UpdateTransaction(this.repository);

  Future<void> call(Transaction transaction) async {
    return await repository.updateTransaction(transaction);
  }
}
