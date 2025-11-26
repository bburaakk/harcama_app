import 'package:equatable/equatable.dart';
import 'package:harcama_app/domain/entities/category.dart';

class Expense extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  @override
  List<Object?> get props => [id, title, amount, date, category];
}
