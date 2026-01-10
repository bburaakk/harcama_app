import 'package:hive/hive.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/domain/repositories/transaction_repository.dart';

import 'base_repository_impl.dart';

class TransactionRepositoryImpl extends BaseRepositoryImpl<Transaction> implements TransactionRepository {

  TransactionRepositoryImpl(Box<Transaction> box) : super(box) {
    _migrateMissingIds(box);
  }

  Future<void> _migrateMissingIds(Box<Transaction> box) async {
    // Assign a stable id for any transaction missing an id (empty string)
    for (final key in box.keys.toList()) {
      final tx = box.get(key);
      if (tx != null && tx.id.isEmpty) {
        final migrated = Transaction(
          id: key.toString(),
          title: tx.title,
          amount: tx.amount,
          date: tx.date,
          entryDate: tx.entryDate,
          category: tx.category,
          type: tx.type,
          isRecurring: tx.isRecurring,
          ledgerID: tx.ledgerID,
          accountID: tx.accountID,
        );
        await box.put(key, migrated);
      }
    }
  }
}