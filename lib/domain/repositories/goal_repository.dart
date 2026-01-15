import 'package:harcama_app/domain/entities/goal.dart';
import 'package:harcama_app/domain/repositories/base_repository.dart';

abstract class GoalRepository extends BaseRepository<Goal> {
  Future<List<Goal>> getGoalsByStatus(GoalStatus status);
  Future<List<Goal>> getGoalsByLedger(String ledgerID);
  Future<void> updateGoalAmount(String goalId, double newAmount);
}