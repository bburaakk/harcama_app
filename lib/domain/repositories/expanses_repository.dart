import '../../domain/entities/expanses.dart';

abstract class ExpansesRepository {
  Future<List<Expanses>> getExpanses();
  Future<void> addExpanses(Expanses expanses);
  Future<void> deleteExpanses(String id);
  Future<void> updateExpanses(Expanses expanses);
}


