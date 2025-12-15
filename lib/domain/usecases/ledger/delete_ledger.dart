import 'package:harcama_app/domain/repositories/ledger_repository.dart';

class DeleteLedger {
  final LedgerRepository repository;

  DeleteLedger(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteLedger(id);
  }

}