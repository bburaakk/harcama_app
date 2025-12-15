import 'package:harcama_app/domain/entities/ledger.dart';
import 'package:harcama_app/domain/repositories/ledger_repository.dart';

class AddLedger{
  final LedgerRepository repository;

  AddLedger(this.repository);

  Future<void> call(Ledger ledger) async {
    return await repository.addLedger(ledger);
  }
}

