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

  List<Transaction> get transactions => items;

  Category? getMostExpensiveCategoryByDate(int targetMonth, int targetYear) {
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

    return categoryObjects[topEntry.key];
  }
}