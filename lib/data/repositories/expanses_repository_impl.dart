import 'package:harcama_app/domain/entities/expanses.dart';
import 'package:harcama_app/domain/repositories/expanses_repository.dart';
import 'package:uuid/uuid.dart';

class ExpansesRepositoryImpl implements ExpansesRepository {
  final List<Expanses> denemeExpanses = [];
  var uuid = Uuid();

  @override
  Future<void> addExpanse(Expanses expanse) async {
    final newExpanse = Expanses(
      id: uuid.v4(),
      title: expanse.title,
      amount: expanse.amount,
      date: expanse.date,
      category: expanse.category,
    );
    denemeExpanses.add(newExpanse);
  }

  @override
  Future<List<Expanses>> getExpanses() async {
    return List.from(denemeExpanses);
  }

  @override
  Future<void> deleteExpanse(String id) async {
    denemeExpanses.removeWhere((expanse) => expanse.id == id);
  }

  @override
  Future<void> updateExpanse(Expanses expanse) async {
    final index = denemeExpanses.indexWhere((e) => e.id == expanse.id);
    if (index != -1) {
      denemeExpanses[index] = expanse;
    }
  }
}