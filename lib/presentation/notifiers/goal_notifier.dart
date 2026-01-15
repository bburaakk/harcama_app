import 'package:flutter/widgets.dart';
import 'package:harcama_app/domain/entities/goal.dart';
import 'package:harcama_app/presentation/notifiers/base_notifier.dart';

class GoalNotifier extends BaseNotifier<Goal> {
  GoalNotifier({
    required super.createUseCase,
    required super.updateUseCase,
    required super.deleteUseCase,
    required super.getAllUseCase,
  }) {
    // Initialize with sample data if empty
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchItems();
      if (items.isEmpty) {
        await _createSampleGoals();
      }
    });
  }

  String _searchQuery = '';
  GoalStatus _selectedStatus = GoalStatus.active;

  String get searchQuery => _searchQuery;
  GoalStatus get selectedStatus => _selectedStatus;

  List<Goal> get goals {
    var filteredGoals = items
        .where((goal) => goal.status == _selectedStatus)
        .toList();

    if (_searchQuery.isEmpty) {
      return filteredGoals;
    }

    return filteredGoals.where((goal) {
      final queryLower = _searchQuery.toLowerCase();
      final titleLower = goal.title.toLowerCase();
      final descriptionLower = goal.description.toLowerCase();

      return titleLower.contains(queryLower) ||
          descriptionLower.contains(queryLower);
    }).toList();
  }

  List<Goal> get activeGoals =>
      items.where((goal) => goal.status == GoalStatus.active).toList();
  List<Goal> get completedGoals =>
      items.where((goal) => goal.status == GoalStatus.completed).toList();

  double get totalProgress {
    final active = activeGoals;
    if (active.isEmpty) return 0.0;

    final totalTargetAmount = active.fold(
      0.0,
      (sum, goal) => sum + goal.targetAmount,
    );
    final totalCurrentAmount = active.fold(
      0.0,
      (sum, goal) => sum + goal.currentAmount,
    );

    return totalTargetAmount > 0
        ? (totalCurrentAmount / totalTargetAmount).clamp(0.0, 1.0)
        : 0.0;
  }

  int get activeStreakDays {
    // Bu örnek implementasyon - gerçek streak mantığınıza göre düzenlenebilir
    final now = DateTime.now();
    final recentGoals = activeGoals.where((goal) {
      return now.difference(goal.updatedAt).inDays <= 30;
    }).toList();
    return recentGoals.length * 2; // Basit bir hesaplama örneği
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedStatus(GoalStatus status) {
    _selectedStatus = status;
    notifyListeners();
  }

  Future<void> createGoal({
    required String title,
    String description = '',
    required double targetAmount,
    DateTime? targetDate,
    String icon = '🎯',
    String color = 'primary',
    required String ledgerID,
    required String accountID,
  }) async {
    final now = DateTime.now();
    final goal = Goal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      targetAmount: targetAmount,
      currentAmount: 0.0,
      startDate: now,
      targetDate: targetDate,
      status: GoalStatus.active,
      icon: icon,
      color: color,
      createdAt: now,
      updatedAt: now,
      ledgerID: ledgerID,
      accountID: accountID,
    );

    await addItem(goal);
  }

  Future<void> updateGoalAmount(String goalId, double newAmount) async {
    final goal = items.firstWhere((g) => g.id == goalId);
    final updatedGoal = goal.copyWith(
      currentAmount: newAmount,
      updatedAt: DateTime.now(),
      status: newAmount >= goal.targetAmount
          ? GoalStatus.completed
          : goal.status,
    );
    await updateItem(updatedGoal);
  }

  Future<void> updateGoalStatus(String goalId, GoalStatus status) async {
    final goal = items.firstWhere((g) => g.id == goalId);
    final updatedGoal = goal.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
    await updateItem(updatedGoal);
  }

  List<Goal> getGoalsByLedger(String ledgerID) {
    return items.where((goal) => goal.ledgerID == ledgerID).toList();
  }

  Future<void> _createSampleGoals() async {
    final now = DateTime.now();

    // Sample goals
    final sampleGoals = [
      Goal(
        id: '1',
        title: 'Vacation Fund',
        description: 'Save for summer vacation',
        targetAmount: 2000.0,
        currentAmount: 1200.0,
        startDate: now.subtract(const Duration(days: 30)),
        targetDate: now.add(const Duration(days: 60)),
        status: GoalStatus.active,
        icon: '🏖️',
        color: 'orange',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
        ledgerID: 'default',
        accountID: 'default',
      ),
      Goal(
        id: '2',
        title: 'Emergency Fund',
        description: 'Financial safety net',
        targetAmount: 5000.0,
        currentAmount: 4500.0,
        startDate: now.subtract(const Duration(days: 90)),
        targetDate: null,
        status: GoalStatus.active,
        icon: '🛡️',
        color: 'blue',
        createdAt: now.subtract(const Duration(days: 90)),
        updatedAt: now,
        ledgerID: 'default',
        accountID: 'default',
      ),
      Goal(
        id: '3',
        title: 'New Laptop',
        description: 'Upgrade my work laptop',
        targetAmount: 1500.0,
        currentAmount: 800.0,
        startDate: now.subtract(const Duration(days: 15)),
        targetDate: now.add(const Duration(days: 45)),
        status: GoalStatus.active,
        icon: '💻',
        color: 'purple',
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now,
        ledgerID: 'default',
        accountID: 'default',
      ),
    ];

    for (final goal in sampleGoals) {
      await addItem(goal);
    }
  }
}
