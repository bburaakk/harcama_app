import '../repositories/expanses_repository.dart';

class DeleteExpanse {
  final ExpansesRepository repository;

  DeleteExpanse(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteExpanses(id);
  }
}
