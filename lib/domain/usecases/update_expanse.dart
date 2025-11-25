import '../entities/expanses.dart';
import '../repositories/expanses_repository.dart';

class UpdateExpanse {
  final ExpansesRepository repository;

  UpdateExpanse(this.repository);

  Future<void> call(Expanses expanse) async {
    return await repository.updateExpanses(expanse);
  }
}
