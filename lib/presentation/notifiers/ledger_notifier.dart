import 'package:harcama_app/domain/entities/ledger.dart';
import 'package:harcama_app/presentation/notifiers/base_notifier.dart';

class LedgerNotifier extends BaseNotifier<Ledger> {
  LedgerNotifier({
    required super.createUseCase,
    required super.updateUseCase,
    required super.deleteUseCase,
    required super.getAllUseCase,
  });

  Ledger? selectedLedger;

  List<Ledger> get ledgers => items;

  @override
  Future<void> fetchItems() async {
    await super.fetchItems();

    if (items.isEmpty) {
      final defaultLedger = Ledger(
        accountID: "default",
        id: 'default',
        name: 'All',
        icon: '📒',
        balance: 0,
      );

      items = [defaultLedger];
      selectedLedger = defaultLedger;
      notifyListeners();
      return;
    }

    selectedLedger ??= items.first;
    notifyListeners();
  }

  void selectLedger(Ledger ledger) {
    selectedLedger = ledger;
    notifyListeners();
  }
}
