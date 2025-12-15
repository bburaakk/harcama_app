import 'package:equatable/equatable.dart';
import 'package:harcama_app/domain/entities/category.dart';
import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
enum TransactionType {
  @HiveField(0)
  expense,
  @HiveField(1)
  income,
  @HiveField(2)
  transfer,
}
@HiveType(typeId: 1)
class Transaction extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final DateTime entryDate;
  @HiveField(5)
  final Category? category;
  @HiveField(6)
  final TransactionType type;
  @HiveField(7)
  final bool isRecurring;
  @HiveField(8)
  final String ledgerID;
  @HiveField(9)
  final String accountID;


  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.entryDate,
    this.category,
    required this.type,
    this.isRecurring = false,
    required this.ledgerID,
    required this.accountID,
  });

  @override
  List<Object?> get props => [id, title, amount, date, entryDate, category, type, isRecurring, ledgerID, accountID];
}
