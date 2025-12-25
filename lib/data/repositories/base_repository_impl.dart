import 'package:hive/hive.dart';
import 'package:harcama_app/domain/repositories/base_repository.dart';
import 'package:harcama_app/domain/entities/base_entity.dart';

class BaseRepositoryImpl<T extends BaseEntity> implements BaseRepository<T> {
  final Box<T> box;
  BaseRepositoryImpl(this.box);

  @override
  Future<void> add(T entity) async {
    await box.add(entity);
  }

  @override
  Future<void> delete(String id) async {
    final key = box.keys.firstWhere((k) => box.get(k)?.id == id, orElse: () => null);
    if (key != null) {
      await box.delete(key);
    }
  }

  @override
  Future<List<T>> getAll() async {
    return box.values.toList();
  }

  @override
  Future<T?> getById(String id) async {
    try {
      return box.values.firstWhere((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> update(T entity) async {
    final key = box.keys.firstWhere((k) => box.get(k)?.id == entity.id, orElse: () => null);
    if (key != null) {
      await box.put(key, entity);
    }
  }
}