import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/domain/repositories/transaction_repository.dart';
import 'package:uuid/uuid.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final List<Transaction> _transactions = [];
  var uuid = Uuid();

  @override
  Future<void> addTransaction(Transaction transaction) async {
    final newTransaction = Transaction(
      id: uuid.v4(),
      title: transaction.title,
      amount: transaction.amount,
      date: transaction.date,
      category: transaction.category,
      type: transaction.type,
      isRecurring: transaction.isRecurring,
    );
    _transactions.add(newTransaction);
  }

  @override
  Future<List<Transaction>> getTransactions() async { // Test için şimdilik dursun
    if (_transactions.isEmpty) {
      _transactions.addAll([
        Transaction(
          id: '1',
          title: 'Kahve',
          amount: 15.0,
          date: DateTime.now(),
          category: const Category(id: '1', title: 'Yemek', icon: '🍔'),
          type: TransactionType.expense,
        ),
        Transaction(
          id: '2',
          title: 'Maaş',
          amount: 5000.0,
          date: DateTime.now().subtract(const Duration(days: 1)),
          type: TransactionType.income,
          isRecurring: true,
        ),
      ]);
    }
    return List.from(_transactions);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((transaction) => transaction.id == id);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
    }
  }
}
