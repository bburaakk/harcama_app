import 'package:equatable/equatable.dart';
import 'package:harcama_app/domain/entities/category.dart';

enum TransactionType {
  expense,
  income,
  transfer,
}

class Transaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category? category;
  final TransactionType type;
  final bool isRecurring;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    this.category,
    required this.type,
    this.isRecurring = false,
  });

  @override
  List<Object?> get props => [id, title, amount, date, category, type, isRecurring];
}
