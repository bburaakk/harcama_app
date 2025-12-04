import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/domain/repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<List<Transaction>> call() async {
    return await repository.getTransactions();
  }
}
