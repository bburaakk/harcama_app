import 'package:harcama_app/domain/entities/account.dart';
import 'package:harcama_app/domain/repositories/account_repository.dart';

class GetAccount {
  final AccountRepository repository;

  GetAccount(this.repository);

  Future<List<Account>> call() async {
    return await repository.getAccounts();
  }
}