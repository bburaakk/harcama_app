import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/repositories/category_repository.dart';

class GetCategory {
  final CategoryRepository repository;

  GetCategory(this.repository);

  Future<List<Category>> call() async {
    return await repository.getCategories();
  }
}