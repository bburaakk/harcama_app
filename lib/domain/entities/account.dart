import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:harcama_app/domain/entities/base_entity.dart';
part 'account.g.dart';

@HiveType(typeId: 3)
class Account extends Equatable implements BaseEntity {
  @HiveField(0)
  @override
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String currency;
  @HiveField(3)
  final double balance;
  @HiveField(4)
  final DateTime createdTime;

  const Account({
    required this.id,
    required this.name,
    required this.currency,
    required this.balance,
    required this.createdTime
  });
  
  @override
  List<Object?> get props => [id, name, currency, balance, createdTime];
}
