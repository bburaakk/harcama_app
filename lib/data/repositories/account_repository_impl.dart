import 'package:hive/hive.dart';
import 'package:harcama_app/domain/entities/account.dart';
import 'package:harcama_app/domain/repositories/account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final Box<Account> accountBox;
  AccountRepositoryImpl(this.accountBox);

  @override
  Future<void> addAccount(Account account) async {
    await accountBox.add(account);
  }

  @override
  Future<void> deleteAccount(String id) async {
    final key = accountBox.keys.firstWhere((k) => accountBox.get(k)?.id == id, orElse: () => null);
    if (key != null) {
      await accountBox.delete(key);
    }
  }

  @override
  Future<List<Account>> getAccounts() async {
    return accountBox.values.toList();
  }

  @override
  Future<void> updateAccount(Account account) async {
    final key = accountBox.keys.firstWhere((k) => accountBox.get(k)?.id == account.id, orElse: () => null);
    if (key != null) {
      await accountBox.put(key, account);
    }
  }
}