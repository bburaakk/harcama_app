import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String icon;
  @HiveField(3)
  final double monthlyBudget;

  const Category({
    required this.id,
    required this.title,
    required this.icon,
    this.monthlyBudget = 0.0,
  });

  @override
  List<Object?> get props => [id, title, icon, monthlyBudget];
}
