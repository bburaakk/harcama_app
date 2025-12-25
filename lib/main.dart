import 'package:flutter/material.dart';
import 'package:harcama_app/data/repositories/account_repository_impl.dart';
import 'package:harcama_app/data/repositories/category_repository_impl.dart';
import 'package:harcama_app/data/repositories/ledger_repository_impl.dart';
import 'package:harcama_app/domain/entities/account.dart';
import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/entities/ledger.dart';
import 'package:harcama_app/domain/usecases/generic_usecase.dart';
import 'package:harcama_app/presentation/notifiers/account_notifier.dart';
import 'package:harcama_app/presentation/notifiers/category_notifier.dart';
import 'package:harcama_app/presentation/notifiers/ledger_notifier.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:harcama_app/data/repositories/transaction_repository_impl.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/notifiers/theme_notifier.dart';
import 'package:harcama_app/presentation/pages/main_screen.dart';
import 'package:harcama_app/domain/entities/transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(LedgerAdapter());

  final transactionBox = await Hive.openBox<Transaction>('transactions');
  final categoryBox = await Hive.openBox<Category>('categories');
  final accountBox = await Hive.openBox<Account>('accounts');
  final ledgerBox = await Hive.openBox<Ledger>('ledgers');

  final transactionRepository = TransactionRepositoryImpl(transactionBox);
  final categoryRepository = CategoryRepositoryImpl(categoryBox);
  final accountRepository = AccountRepositoryImpl(accountBox);
  final ledgerRepository = LedgerRepositoryImpl(ledgerBox);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionNotifier(
            createUseCase: CreateUseCase<Transaction>(transactionRepository),
            deleteUseCase: DeleteUseCase<Transaction>(transactionRepository),
            getAllUseCase: GetAllUseCase<Transaction>(transactionRepository),
            updateUseCase: UpdateUseCase<Transaction>(transactionRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryNotifier(
            createUseCase: CreateUseCase<Category>(categoryRepository),
            deleteUseCase: DeleteUseCase<Category>(categoryRepository),
            getAllUseCase: GetAllUseCase<Category>(categoryRepository),
            updateUseCase: UpdateUseCase<Category>(categoryRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AccountNotifier(
            createUseCase: CreateUseCase<Account>(accountRepository),
            deleteUseCase: DeleteUseCase<Account>(accountRepository),
            getAllUseCase: GetAllUseCase<Account>(accountRepository),
            updateUseCase: UpdateUseCase<Account>(accountRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LedgerNotifier(
            createUseCase: CreateUseCase<Ledger>(ledgerRepository),
            deleteUseCase: DeleteUseCase<Ledger>(ledgerRepository),
            getAllUseCase: GetAllUseCase<Ledger>(ledgerRepository),
            updateUseCase: UpdateUseCase<Ledger>(ledgerRepository),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeNotifier.currentTheme,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}