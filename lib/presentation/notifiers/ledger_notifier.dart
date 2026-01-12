import 'package:harcama_app/domain/entities/ledger.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/notifiers/base_notifier.dart';

class LedgerNotifier extends BaseNotifier<Ledger> {
  LedgerNotifier({
    required super.createUseCase,
    required super.updateUseCase,
    required super.deleteUseCase,
    required super.getAllUseCase,
  });

  late Ledger allLedger;
  Ledger? selectedLedger;

  List<Ledger> get ledgers => items;
  List<Ledger> get userLedgers => items;

  @override
  Future<void> fetchItems() async {
    // All ledger'ı initialize et
    allLedger = Ledger(
      accountID: "default",
      id: 'default',
      name: 'All',
      icon: '📒',
      balance: 0,
    );

    await super.fetchItems();

    // Database'deki All ledger'ı itemsden çıkar
    items.removeWhere((l) => l.id == 'default');

    if (items.isEmpty) {
      selectedLedger ??= allLedger;
    } else {
      selectedLedger ??= items.first;
    }

    notifyListeners();
  }

  void selectLedger(Ledger ledger) {
    selectedLedger = ledger;
    notifyListeners();
  }

  /// Ledger'ın balance'ını transaction'lar bazında günceller
  void updateLedgerBalance(String ledgerId, List<Transaction> transactions) {
    // All ledger balance'ını her zaman güncelle
    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpense = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalBalance = totalIncome - totalExpense;
    allLedger = allLedger.copyWith(balance: totalBalance);

    if (selectedLedger?.id == 'default') {
      selectedLedger = allLedger;
    }

    final ledgerIndex = items.indexWhere((l) => l.id == ledgerId);
    if (ledgerIndex == -1) {
      notifyListeners();
      return;
    }

    final ledgerTransactions =
        transactions.where((t) => t.ledgerID == ledgerId).toList();

    final income = ledgerTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final expense = ledgerTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final newBalance = income - expense;

    final updatedLedger = items[ledgerIndex].copyWith(balance: newBalance);
    items[ledgerIndex] = updatedLedger;

    if (selectedLedger?.id == ledgerId) {
      selectedLedger = updatedLedger;
    }

    notifyListeners();
  }
}
