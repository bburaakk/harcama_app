import '../entities/expanses.dart';
import '../repositories/expanses_repository.dart';

class AddExpanse {
  final ExpansesRepository repository;

  AddExpanse(this.repository);

  Future<void> call(Expanses expanse) async {
    return await repository.addExpanses(expanse);
  }
}
