import 'package:harcama_app/domain/entities/ledger.dart';

abstract class LedgerRepository {
  Future<List<Ledger>> getLedgers();
  Future<void> addLedger(Ledger ledger);
  Future<void> deleteLedger(String id);
  Future<void> updateLedger(Ledger ledger);
}
