import 'package:hive/hive.dart';
import 'package:harcama_app/domain/entities/account.dart';
import 'package:harcama_app/domain/repositories/account_repository.dart';
import 'base_repository_impl.dart';

class AccountRepositoryImpl extends BaseRepositoryImpl<Account> implements AccountRepository {

  AccountRepositoryImpl(Box<Account> box) : super(box);
}