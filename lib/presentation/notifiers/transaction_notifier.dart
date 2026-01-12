import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/notifiers/base_notifier.dart';
import 'package:harcama_app/presentation/notifiers/ledger_notifier.dart';

class TransactionNotifier extends BaseNotifier<Transaction> {
  final LedgerNotifier? ledgerNotifier;

  TransactionNotifier({
    required super.createUseCase,
    required super.updateUseCase,
    required super.deleteUseCase,
    required super.getAllUseCase,
    this.ledgerNotifier,
  });

  String _searchQuery = '';
  double monthlyBudget = 0;

  List<Transaction> get transactions {
    if (_searchQuery.isEmpty) {
      return items;
    }

    return items.where((t) {
      final queryLower = _searchQuery.toLowerCase();
      final titleLower = t.title.toLowerCase();
      final categoryLower = t.category?.title.toLowerCase() ?? '';

      return titleLower.contains(queryLower) || categoryLower.contains(queryLower);
    }).toList();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  @override
  Future<void> addItem(Transaction item) async {
    await super.addItem(item);
    _updateLedgerBalance(item.ledgerID);
  }

  @override
  Future<void> updateItem(Transaction item) async {
    await super.updateItem(item);
    _updateLedgerBalance(item.ledgerID);
  }

  @override
  Future<void> deleteItem(String id) async {
    final transaction = items.firstWhere((t) => t.id == id);
    await super.deleteItem(id);
    _updateLedgerBalance(transaction.ledgerID);
  }

  void _updateLedgerBalance(String ledgerId) {
    if (ledgerNotifier != null) {
      ledgerNotifier!.updateLedgerBalance(ledgerId, items);
    }
  }
  
  void setMonthlyBudget(double amount) {
    monthlyBudget = amount;
    notifyListeners();
  }

  Map<String, dynamic>? getMostExpensiveCategoryInfo(int targetMonth, int targetYear, {int? targetDay}) {
    final filteredList = items.where((t) {
      return t.date.month == targetMonth &&
          t.date.year == targetYear &&
          (targetDay == null || t.date.day == targetDay) &&
          t.type == TransactionType.expense &&
          t.category != null;
    }).toList();

    if (filteredList.isEmpty) return null;

    final Map<String, double> categoryTotals = {};
    final Map<String, Category> categoryObjects = {};

    for (var t in filteredList) {
      final catId = t.category!.id;
      categoryTotals[catId] = (categoryTotals[catId] ?? 0) + t.amount;
      categoryObjects.putIfAbsent(catId, () => t.category!);
    }

    if (categoryTotals.isEmpty) return null;

    final topEntry = categoryTotals.entries.reduce((a, b) => a.value > b.value ? a : b);

    return {
      'category': categoryObjects[topEntry.key],
      'amount': topEntry.value,
    };
  }

  Map<String, dynamic> getBudgetOverview(int month, int year) {
    final totalExpense = items
        .where((t) => t.date.month == month && t.date.year == year && t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final remainingBudget = monthlyBudget - totalExpense;

    final now = DateTime.now();
    final daysInMonth = DateTime(year, month + 1, 0).day;

    int daysLeft = 0;
    if (now.month == month && now.year == year) {
      daysLeft = daysInMonth - now.day;
    } else {
      daysLeft = 0; 
    }

    double dailyAvailable = 0;
    if (daysLeft > 0 && remainingBudget > 0) {
      dailyAvailable = remainingBudget / daysLeft;
    } else if (daysLeft == 0 && remainingBudget > 0) {
       dailyAvailable = remainingBudget;
    }

    return {
      'totalBudget': monthlyBudget,
      'spent': totalExpense,
      'remaining': remainingBudget,
      'daysLeft': daysLeft,
      'dailyAvailable': dailyAvailable,
    };
  }

  List<Transaction> getFilteredTransactions(String timeframe) {
    final now = DateTime.now();
    return items.where((t) {
      if (t.type != TransactionType.expense) return false;
      
      if (timeframe == 'Weekly') {
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final startOfWeekDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        final endOfWeekDate = startOfWeekDate.add(const Duration(days: 7));
        return t.date.isAfter(startOfWeekDate.subtract(const Duration(seconds: 1))) && 
               t.date.isBefore(endOfWeekDate);
      } else if (timeframe == 'Monthly') {
        return t.date.month == now.month && t.date.year == now.year;
      } else if (timeframe == 'Yearly') {
        return t.date.year == now.year;
      }
      return true;
    }).toList();
  }
}
