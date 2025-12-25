import 'package:harcama_app/domain/entities/account.dart';
import 'package:harcama_app/presentation/notifiers/base_notifier.dart';

class AccountNotifier extends BaseNotifier<Account> {
  AccountNotifier({
    required super.createUseCase,
    required super.updateUseCase,
    required super.deleteUseCase,
    required super.getAllUseCase,
  });

  List<Account> get accounts => items;
}