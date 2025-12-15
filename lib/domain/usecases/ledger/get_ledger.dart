import 'package:harcama_app/domain/entities/ledger.dart';
import 'package:harcama_app/domain/repositories/ledger_repository.dart';

class GetLedger {
  final LedgerRepository repository;

  GetLedger(this.repository);

  Future<List<Ledger>> call() async {
    return await repository.getLedgers();
  }
}