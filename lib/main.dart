import 'package:flutter/material.dart';
import 'package:harcama_app/data/repositories/category_repository_impl.dart';
import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/usecases/category/add_category.dart';
import 'package:harcama_app/domain/usecases/category/delete_category.dart';
import 'package:harcama_app/domain/usecases/category/get_category.dart';
import 'package:harcama_app/domain/usecases/category/update_category.dart';
import 'package:harcama_app/presentation/notifiers/category_notifier.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:harcama_app/data/repositories/transaction_repository_impl.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/notifiers/theme_notifier.dart';
import 'package:harcama_app/presentation/pages/main_screen.dart';
import 'package:harcama_app/domain/usecases/transaction/add_transaction.dart';
import 'package:harcama_app/domain/usecases/transaction/delete_transaction.dart';
import 'package:harcama_app/domain/usecases/transaction/get_transactions.dart';
import 'package:harcama_app/domain/usecases/transaction/update_transaction.dart';
import 'package:harcama_app/domain/entities/transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());

  final transactionBox = await Hive.openBox<Transaction>('transactions');
  final categoryBox = await Hive.openBox<Category>('categories');
  final transactionRepository = TransactionRepositoryImpl(transactionBox);
  final categoryRepository = CategoryRepositoryImpl(categoryBox);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionNotifier(
            addTransaction: AddTransaction(transactionRepository),
            deleteTransaction: DeleteTransaction(transactionRepository),
            getTransactions: GetTransactions(transactionRepository),
            updateTransaction: UpdateTransaction(transactionRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryNotifier(
            addCategory: AddCategory(categoryRepository),
            deleteCategory: DeleteCategory(categoryRepository),
            getCategories: GetCategory(categoryRepository),
            updateCategory: UpdateCategory(categoryRepository),
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