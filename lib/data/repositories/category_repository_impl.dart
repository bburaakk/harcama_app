import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/repositories/category_repository.dart';
import 'package:uuid/uuid.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final List<Category> _categories = [];
  final Uuid _uuid = Uuid();

  @override
  Future<void> addCategory(Category category) async {
    final newCategory = Category(
      id: _uuid.v4(),
      title: category.title,
      icon: category.icon,
    );
    _categories.add(newCategory);
  }

  @override
  Future<void> deleteCategory(String id) async {
    _categories.removeWhere((category) => category.id == id);
  }

  @override
  Future<List<Category>> getCategories() async {
    return List.from(_categories);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final index = _categories.indexWhere((e) => e.id == category.id);
    if (index != -1) {
      _categories[index] = category;
    }
  }

}