import 'package:hive/hive.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/domain/repositories/transaction_repository.dart';

import 'base_repository_impl.dart';

class TransactionRepositoryImpl extends BaseRepositoryImpl<Transaction> implements TransactionRepository {

  TransactionRepositoryImpl(Box<Transaction> box) : super(box);
}