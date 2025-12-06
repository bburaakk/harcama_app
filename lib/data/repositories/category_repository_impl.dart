import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/repositories/category_repository.dart';
import 'package:hive/hive.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final Box<Category> _categoryBox;
  CategoryRepositoryImpl(this._categoryBox);
  @override
  Future<void> addCategory(Category category) async {
    await _categoryBox.put(category.id, category);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _categoryBox.delete(id);
  }

  @override
  Future<List<Category>> getCategories() async {
    return _categoryBox.values.toList();
  }

  @override
  Future<void> updateCategory(Category category) async {
    await _categoryBox.put(category.id, category);
  }

}