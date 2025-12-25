import 'package:hive/hive.dart';
import 'package:harcama_app/domain/entities/ledger.dart';
import 'package:harcama_app/domain/repositories/ledger_repository.dart';

import 'base_repository_impl.dart';

class LedgerRepositoryImpl extends BaseRepositoryImpl<Ledger> implements LedgerRepository {

  LedgerRepositoryImpl(Box<Ledger> box) : super(box);
}