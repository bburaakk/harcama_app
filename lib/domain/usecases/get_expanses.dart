import '../entities/expanses.dart';
import '../repositories/expanses_repository.dart';

class GetExpanses {
  final ExpansesRepository repository;

  GetExpanses(this.repository);

  Future<List<Expanses>> call() async {
    return await repository.getExpanses();
  }
}
