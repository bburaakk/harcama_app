import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/repositories/category_repository.dart';
import 'package:hive/hive.dart';

import 'base_repository_impl.dart';

class CategoryRepositoryImpl extends BaseRepositoryImpl<Category> implements CategoryRepository {

  CategoryRepositoryImpl(Box<Category> box) : super(box);
}