import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/usecases/category/add_category.dart';
import 'package:harcama_app/domain/usecases/category/delete_category.dart';
import 'package:harcama_app/domain/usecases/category/get_category.dart';
import 'package:harcama_app/domain/usecases/category/update_category.dart';

class CategoryNotifier extends ChangeNotifier{
  final AddCategory addCategory;
  final DeleteCategory deleteCategory;
  final GetCategory getCategory;
  final UpdateCategory updateCategory;

  CategoryNotifier({
    required this.getCategory,
    required this.addCategory,
    required this.updateCategory,
    required this.deleteCategory,
  }){
    fetchCategories();
  }
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  Future<void> fetchCategories() async {
    _setLoading(true);
    try {
      _categories = await getCategory();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Fuck!! kategoriler yüklenirken bir aksilik oldu: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addNewCategory(Category category) async {
    _setLoading(true);
    try {
      await addCategory(category);
      await fetchCategories();
    } catch (e) {
      _errorMessage = 'Fuck!! kategorileri ekleyemedin dostum: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateExistingCategory(Category category) async {
    _setLoading(true);
    try {
      await updateCategory(category);
      await fetchCategories();
    } catch (e) {
      _errorMessage = 'Fuck!! kategorileri günceleyemedim bro: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteExistingCategory(String id) async {
    _setLoading(true);
    try {
      await deleteCategory(id);
      await fetchCategories();
    } catch (e) {
      _errorMessage = 'Fuck!! kategorileri silemedim dostum: $e';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

}