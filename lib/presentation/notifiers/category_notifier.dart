import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/presentation/notifiers/base_notifier.dart';

class CategoryNotifier extends BaseNotifier<Category> {
  CategoryNotifier({
    required super.createUseCase,
    required super.updateUseCase,
    required super.deleteUseCase,
    required super.getAllUseCase,
  });

  List<Category> get categories => items;

  @override
  Future<void> fetchItems() async {
    await super.fetchItems();
    if (items.isEmpty) {
      await _addDefaultCategories();
    }
  }

  Future<void> _addDefaultCategories() async {
    final defaultCategories = [
      const Category(id: 'def_1', title: 'Supermarket', icon: '🛒'),
      const Category(id: 'def_2', title: 'Transport', icon: '🚌'),
      const Category(id: 'def_3', title: 'Food', icon: '🍔'),
      const Category(id: 'def_4', title: 'Bills', icon: '🧾'),
      const Category(id: 'def_5', title: 'Fun', icon: '🎬'),
      const Category(id: 'def_6', title: 'Health', icon: '🏥'),
      const Category(id: 'def_7', title: 'Clothing', icon: '👕'),
      const Category(id: 'def_8', title: 'Salary', icon: '💰'),
      const Category(id: 'def_9', title: 'Rent', icon: '🏠'),
      const Category(id: 'def_10', title: 'Education', icon: '📚'),
    ];

    for (var category in defaultCategories) {
      await createUseCase(category);
    }
    await super.fetchItems();
  }
}
