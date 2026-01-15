import 'package:hive/hive.dart';
import 'package:harcama_app/domain/entities/goal.dart';
import 'package:harcama_app/domain/repositories/goal_repository.dart';
import 'package:harcama_app/data/repositories/base_repository_impl.dart';

class GoalRepositoryImpl extends BaseRepositoryImpl<Goal> implements GoalRepository {
  GoalRepositoryImpl(Box<Goal> box) : super(box);

  @override
  Future<List<Goal>> getGoalsByStatus(GoalStatus status) async {
    final allGoals = await getAll();
    return allGoals.where((goal) => goal.status == status).toList();
  }

  @override
  Future<List<Goal>> getGoalsByLedger(String ledgerID) async {
    final allGoals = await getAll();
    return allGoals.where((goal) => goal.ledgerID == ledgerID).toList();
  }

  @override
  Future<void> updateGoalAmount(String goalId, double newAmount) async {
    final goal = await getById(goalId);
    if (goal != null) {
      final updatedGoal = goal.copyWith(
        currentAmount: newAmount,
        updatedAt: DateTime.now(),
        status: newAmount >= goal.targetAmount ? GoalStatus.completed : goal.status,
      );
      await update(updatedGoal);
    }
  }
}