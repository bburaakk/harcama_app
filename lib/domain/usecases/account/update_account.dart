import 'package:harcama_app/domain/entities/account.dart';
import 'package:harcama_app/domain/repositories/account_repository.dart';

class UpdateAccount{
  final AccountRepository repository;

  UpdateAccount(this.repository);

  Future<void> call(Account account) async {
    return await repository.updateAccount(account);
  }

}