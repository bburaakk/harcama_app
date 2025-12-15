import 'package:harcama_app/domain/entities/ledger.dart';
import 'package:harcama_app/domain/repositories/ledger_repository.dart';

class UpdateLedger {
  final LedgerRepository repository;

  UpdateLedger(this.repository);

  Future<void> call(Ledger ledger) async {
    return await repository.updateLedger(ledger);
  }

}