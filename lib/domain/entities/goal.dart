import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:harcama_app/domain/entities/base_entity.dart';

part 'goal.g.dart';

@HiveType(typeId: 5)
enum GoalStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  completed,
  @HiveField(2)
  paused,
  @HiveField(3)
  cancelled,
}

@HiveType(typeId: 6)
class Goal extends Equatable implements BaseEntity {
  @HiveField(0)
  @override
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final double targetAmount;
  
  @HiveField(4)
  final double currentAmount;
  
  @HiveField(5)
  final DateTime startDate;
  
  @HiveField(6)
  final DateTime? targetDate;
  
  @HiveField(7)
  final GoalStatus status;
  
  @HiveField(8)
  final String icon;
  
  @HiveField(9)
  final String color;
  
  @HiveField(10)
  final DateTime createdAt;
  
  @HiveField(11)
  final DateTime updatedAt;
  
  @HiveField(12)
  final String ledgerID;
  
  @HiveField(13)
  final String accountID;

  const Goal({
    required this.id,
    required this.title,
    this.description = '',
    required this.targetAmount,
    this.currentAmount = 0.0,
    required this.startDate,
    this.targetDate,
    this.status = GoalStatus.active,
    this.icon = '🎯',
    this.color = 'primary',
    required this.createdAt,
    required this.updatedAt,
    required this.ledgerID,
    required this.accountID,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        targetAmount,
        currentAmount,
        startDate,
        targetDate,
        status,
        icon,
        color,
        createdAt,
        updatedAt,
        ledgerID,
        accountID,
      ];

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    double? targetAmount,
    double? currentAmount,
    DateTime? startDate,
    DateTime? targetDate,
    GoalStatus? status,
    String? icon,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ledgerID,
    String? accountID,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      startDate: startDate ?? this.startDate,
      targetDate: targetDate ?? this.targetDate,
      status: status ?? this.status,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ledgerID: ledgerID ?? this.ledgerID,
      accountID: accountID ?? this.accountID,
    );
  }

  double get progress => targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
  
  bool get isCompleted => status == GoalStatus.completed || (currentAmount >= targetAmount);
  
  int get daysRemaining {
    if (targetDate == null) return -1;
    return targetDate!.difference(DateTime.now()).inDays.clamp(0, double.maxFinite.toInt());
  }
  
  bool get isOverdue {
    if (targetDate == null) return false;
    return DateTime.now().isAfter(targetDate!) && !isCompleted;
  }
}