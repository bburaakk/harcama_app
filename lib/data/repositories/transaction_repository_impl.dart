import 'package:hive/hive.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final Box<Transaction> transactionBox;
  TransactionRepositoryImpl(this.transactionBox);

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await transactionBox.add(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final key = transactionBox.keys.firstWhere((k) => transactionBox.get(k)?.id == id, orElse: () => null);
    if (key != null) {
      await transactionBox.delete(key);
    }
  }

  @override
  Future<List<Transaction>> getTransactions() async {
    return transactionBox.values.toList();
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final key = transactionBox.keys.firstWhere((k) => transactionBox.get(k)?.id == transaction.id, orElse: () => null);
    if (key != null) {
      await transactionBox.put(key, transaction);
    }
  }
}