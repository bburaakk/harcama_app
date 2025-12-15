import 'package:harcama_app/domain/entities/account.dart';
import 'package:harcama_app/domain/repositories/account_repository.dart';

class AddAccount{
  final AccountRepository repository;

  AddAccount(this.repository);

  Future<void> call(Account account) async {
    return await repository.addAccount(account);
  }
}

