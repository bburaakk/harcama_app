import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/notifiers/base_notifier.dart';

class TransactionNotifier extends BaseNotifier<Transaction> {
  TransactionNotifier({
    required super.createUseCase,
    required super.updateUseCase,
    required super.deleteUseCase,
    required super.getAllUseCase,
  });

  String _searchQuery = '';

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

  Map<String, dynamic>? getMostExpensiveCategoryInfo(int targetMonth, int targetYear) {
    final filteredList = items.where((t) {
      return t.date.month == targetMonth &&
          t.date.year == targetYear &&
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
}
