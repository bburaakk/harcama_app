import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:harcama_app/domain/entities/base_entity.dart';

part 'subscription.g.dart';

@HiveType(typeId: 7)
enum SubscriptionFrequency {
  @HiveField(0)
  daily,
  @HiveField(1)
  weekly,
  @HiveField(2)
  monthly,
  @HiveField(3)
  yearly,
}

@HiveType(typeId: 8)
enum SubscriptionStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  paused,
  @HiveField(2)
  cancelled,
}

@HiveType(typeId: 9)
class Subscription extends Equatable implements BaseEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final SubscriptionFrequency frequency;

  @HiveField(5)
  final DateTime startDate;

  @HiveField(6)
  final DateTime nextBillingDate;

  @HiveField(7)
  final SubscriptionStatus status;

  @HiveField(8)
  final String icon;

  @HiveField(9)
  final String color;

  @HiveField(10)
  final String? category;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  @HiveField(13)
  final int? billingDay; // 1-31 for monthly, 1-7 for weekly (1=Monday), 1-365 for yearly (day of year)

  const Subscription({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.frequency,
    required this.startDate,
    required this.nextBillingDate,
    required this.status,
    required this.icon,
    required this.color,
    this.category,
    this.billingDay,
    required this.createdAt,
    required this.updatedAt,
  });

  double get monthlyAmount {
    switch (frequency) {
      case SubscriptionFrequency.daily:
        return amount * 30;
      case SubscriptionFrequency.weekly:
        return amount * 4.33;
      case SubscriptionFrequency.monthly:
        return amount;
      case SubscriptionFrequency.yearly:
        return amount / 12;
    }
  }

  String get frequencyText {
    switch (frequency) {
      case SubscriptionFrequency.daily:
        return 'Günlük';
      case SubscriptionFrequency.weekly:
        return 'Haftalık';
      case SubscriptionFrequency.monthly:
        return 'Aylık';
      case SubscriptionFrequency.yearly:
        return 'Yıllık';
    }
  }

  DateTime get nextPaymentDate {
    final now = DateTime.now();
    var nextDate = nextBillingDate;

    // If billingDay is specified, use it to calculate proper next payment date
    if (billingDay != null) {
      switch (frequency) {
        case SubscriptionFrequency.daily:
          // For daily, we don't need specific day, just use current logic
          while (nextDate.isBefore(now)) {
            nextDate = nextDate.add(const Duration(days: 1));
          }
          break;
        case SubscriptionFrequency.weekly:
          // billingDay represents day of week (1=Monday, 7=Sunday)
          final targetWeekday = billingDay!;
          nextDate = _getNextWeekday(now, targetWeekday);
          break;
        case SubscriptionFrequency.monthly:
          // billingDay represents day of month (1-31)
          final targetDay = billingDay!;
          nextDate = _getNextMonthlyDate(now, targetDay);
          break;
        case SubscriptionFrequency.yearly:
          // billingDay represents day of year (1-365)
          final targetDayOfYear = billingDay!;
          nextDate = _getNextYearlyDate(now, targetDayOfYear);
          break;
      }
    } else {
      // Fallback to original logic if no billingDay specified
      while (nextDate.isBefore(now)) {
        switch (frequency) {
          case SubscriptionFrequency.daily:
            nextDate = nextDate.add(const Duration(days: 1));
            break;
          case SubscriptionFrequency.weekly:
            nextDate = nextDate.add(const Duration(days: 7));
            break;
          case SubscriptionFrequency.monthly:
            nextDate = DateTime(nextDate.year, nextDate.month + 1, nextDate.day);
            break;
          case SubscriptionFrequency.yearly:
            nextDate = DateTime(nextDate.year + 1, nextDate.month, nextDate.day);
            break;
        }
      }
    }

    return nextDate;
  }

  DateTime _getNextWeekday(DateTime from, int targetWeekday) {
    final currentWeekday = from.weekday;
    int daysUntilTarget = (targetWeekday - currentWeekday + 7) % 7;
    if (daysUntilTarget == 0) daysUntilTarget = 7; // Next week if today is target day
    return DateTime(from.year, from.month, from.day + daysUntilTarget);
  }

  DateTime _getNextMonthlyDate(DateTime from, int targetDay) {
    DateTime nextDate = DateTime(from.year, from.month, targetDay);
    if (nextDate.isBefore(from) || nextDate.isAtSameMomentAs(from)) {
      nextDate = DateTime(from.year, from.month + 1, targetDay);
    }
    
    // Handle month end edge cases
    while (nextDate.day != targetDay) {
      nextDate = DateTime(nextDate.year, nextDate.month + 1, targetDay);
    }
    
    return nextDate;
  }

  DateTime _getNextYearlyDate(DateTime from, int targetDayOfYear) {
    final currentYear = from.year;
    final targetDate = DateTime(currentYear, 1, 1).add(Duration(days: targetDayOfYear - 1));
    
    if (targetDate.isBefore(from) || targetDate.isAtSameMomentAs(from)) {
      return DateTime(currentYear + 1, 1, 1).add(Duration(days: targetDayOfYear - 1));
    }
    
    return targetDate;
  }

  Subscription copyWith({
    String? id,
    String? name,
    String? description,
    double? amount,
    SubscriptionFrequency? frequency,
    DateTime? startDate,
    DateTime? nextBillingDate,
    SubscriptionStatus? status,
    String? icon,
    String? color,
    String? category,
    int? billingDay,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      status: status ?? this.status,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      category: category ?? this.category,
      billingDay: billingDay ?? this.billingDay,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    amount,
    frequency,
    startDate,
    nextBillingDate,
    status,
    icon,
    color,
    category,
    billingDay,
    createdAt,
    updatedAt,
  ];
}
