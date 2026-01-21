import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/account.dart';
import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/entities/ledger.dart';
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
  TransactionType? _filterType;
  Category? _filterCategory;
  Ledger? _filterLedger;
  Account? _filterAccount;
  DateTimeRange? _filterDateRange;
  double monthlyBudget = 0;

  TransactionType? get filterType => _filterType;
  Category? get filterCategory => _filterCategory;
  Ledger? get filterLedger => _filterLedger;
  Account? get filterAccount => _filterAccount;
  DateTimeRange? get filterDateRange => _filterDateRange;

  List<Transaction> get transactions {
    var result = items;

    if (_searchQuery.isNotEmpty) {
      final queryLower = _searchQuery.toLowerCase();
      result = result.where((t) {
        final titleLower = t.title.toLowerCase();
        final categoryLower = t.category?.title.toLowerCase() ?? '';
        return titleLower.contains(queryLower) || categoryLower.contains(queryLower);
      }).toList();
    }

    if (_filterType != null) {
      result = result.where((t) => t.type == _filterType).toList();
    }

    if (_filterCategory != null) {
      result = result.where((t) => t.category?.id == _filterCategory!.id).toList();
    }

    if (_filterLedger != null) {
      result = result.where((t) => t.ledgerID == _filterLedger!.id).toList();
    }

    if (_filterAccount != null) {
      result = result.where((t) => t.accountID == _filterAccount!.id).toList();
    }

    if (_filterDateRange != null) {
      result = result.where((t) {
        // Normalize dates to ignore time part for inclusive comparison
        final date = DateTime(t.date.year, t.date.month, t.date.day);
        final start = DateTime(_filterDateRange!.start.year, _filterDateRange!.start.month, _filterDateRange!.start.day);
        final end = DateTime(_filterDateRange!.end.year, _filterDateRange!.end.month, _filterDateRange!.end.day);
        
        return (date.isAtSameMomentAs(start) || date.isAfter(start)) && 
               (date.isAtSameMomentAs(end) || date.isBefore(end));
      }).toList();
    }

    return result;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterType(TransactionType? type) {
    _filterType = type;
    notifyListeners();
  }

  void setFilterCategory(Category? category) {
    _filterCategory = category;
    notifyListeners();
  }

  void setFilterLedger(Ledger? ledger) {
    _filterLedger = ledger;
    notifyListeners();
  }

  void setFilterAccount(Account? account) {
    _filterAccount = account;
    notifyListeners();
  }

  void setFilterDateRange(DateTimeRange? range) {
    _filterDateRange = range;
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

  Future<void> clearAllTransactions() async {
    setLoading(true);
    try {
      // Create a copy of the list to avoid concurrent modification issues if fetchItems is called
      final List<Transaction> allTransactions = List.from(items);
      
      for (var transaction in allTransactions) {
        await deleteUseCase(transaction.id);
        // We can update ledger balance after each deletion or once at the end.
        // Updating after each might be safer for consistency if something fails midway,
        // but slower. Let's do it here to be safe.
        // However, since we are clearing ALL, maybe we should just reset ledgers?
        // But ledgers might have initial balances.
        // So deleting transactions one by one and updating ledger is correct logic.
      }
      
      // After deleting all, fetch items to ensure empty state and update UI
      await fetchItems();
      
      // Also need to update ledgers for all affected ledgers.
      // Since we deleted everything, we can just trigger an update for all ledgers involved.
      // But since items is now empty, _updateLedgerBalance might not work as expected if it relies on 'items'.
      // Actually _updateLedgerBalance calls ledgerNotifier.updateLedgerBalance(ledgerId, items).
      // If items is empty, it should calculate balance as 0 (or initial balance).
      
      // Let's collect unique ledger IDs from the deleted transactions
      final uniqueLedgerIds = allTransactions.map((t) => t.ledgerID).toSet();
      for (var ledgerId in uniqueLedgerIds) {
        _updateLedgerBalance(ledgerId);
      }
      
    } catch (e) {
      // Handle error
      print("Error clearing transactions: $e");
    } finally {
      setLoading(false);
    }
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

  List<Transaction> getFilteredTransactions(String timeframe, {DateTime? referenceDate}) {
    final date = referenceDate ?? DateTime.now();
    return items.where((t) {
      if (t.type != TransactionType.expense) return false;
      
      if (timeframe == 'Weekly') {
        final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
        final startOfWeekDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
        final endOfWeekDate = startOfWeekDate.add(const Duration(days: 7));
        return t.date.isAfter(startOfWeekDate.subtract(const Duration(seconds: 1))) && 
               t.date.isBefore(endOfWeekDate);
      } else if (timeframe == 'Monthly') {
        return t.date.month == date.month && t.date.year == date.year;
      } else if (timeframe == 'Yearly') {
        return t.date.year == date.year;
      }
      return true;
    }).toList();
  }
}
