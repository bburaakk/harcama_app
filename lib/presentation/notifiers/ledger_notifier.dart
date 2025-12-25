import 'package:harcama_app/domain/entities/ledger.dart';
import 'package:harcama_app/presentation/notifiers/base_notifier.dart';

class LedgerNotifier extends BaseNotifier<Ledger> {
  LedgerNotifier({
    required super.createUseCase,
    required super.updateUseCase,
    required super.deleteUseCase,
    required super.getAllUseCase,
  });

  List<Ledger> get ledgers => items;
}