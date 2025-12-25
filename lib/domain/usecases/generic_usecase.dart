import 'package:harcama_app/domain/repositories/base_repository.dart';

class CreateUseCase<T> {
  final BaseRepository<T> repository;
  CreateUseCase(this.repository);

  Future<void> call(T entity) async {
    return await repository.add(entity);
  }
}

class UpdateUseCase<T> {
  final BaseRepository<T> repository;
  UpdateUseCase(this.repository);

  Future<void> call(T entity) async {
    return await repository.update(entity);
  }
}

class DeleteUseCase<T> {
  final BaseRepository<T> repository;
  DeleteUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.delete(id);
  }
}

class GetAllUseCase<T> {
  final BaseRepository<T> repository;
  GetAllUseCase(this.repository);

  Future<List<T>> call() async {
    return await repository.getAll();
  }
}

class GetByIdUseCase<T> {
  final BaseRepository<T> repository;
  GetByIdUseCase(this.repository);

  Future<T?> call(String id) async {
    return await repository.getById(id);
  }
}