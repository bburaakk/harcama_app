import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'ledger.g.dart';

@HiveType(typeId: 4)
class Ledger extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String accountID;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final double balance;
  @HiveField(4)
  final String icon;

  const Ledger({
    required this.id,
    required this.accountID,
    required this.name,
    required this.balance,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, accountID, name, balance, icon];

}
