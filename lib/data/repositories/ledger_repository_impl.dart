import 'package:hive/hive.dart';
import 'package:harcama_app/domain/entities/ledger.dart';
import 'package:harcama_app/domain/repositories/ledger_repository.dart';

class LedgerRepositoryImpl implements LedgerRepository {
  final Box<Ledger> ledgerBox;
  LedgerRepositoryImpl(this.ledgerBox);

  @override
  Future<void> addLedger(Ledger ledger) async {
    await ledgerBox.add(ledger);
  }

  @override
  Future<void> deleteLedger(String id) async {
    final key = ledgerBox.keys.firstWhere((k) => ledgerBox.get(k)?.id == id, orElse: () => null);
    if (key != null) {
      await ledgerBox.delete(key);
    }
  }

  @override
  Future<List<Ledger>> getLedgers() async {
    return ledgerBox.values.toList();
  }

  @override
  Future<void> updateLedger(Ledger ledger) async {
    final key = ledgerBox.keys.firstWhere((k) => ledgerBox.get(k)?.id == ledger.id, orElse: () => null);
    if (key != null) {
      await ledgerBox.put(key, ledger);
    }
  }
}