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
}