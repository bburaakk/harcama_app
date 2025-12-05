import 'package:flutter/material.dart';
import 'package:harcama_app/data/repositories/transaction_repository_impl.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/notifiers/theme_notifier.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/presentation/pages/main_screen.dart';
import 'package:harcama_app/domain/usecases/transaction/add_transaction.dart';
import 'package:harcama_app/domain/usecases/transaction/delete_transaction.dart';
import 'package:harcama_app/domain/usecases/transaction/get_transactions.dart';
import 'package:harcama_app/domain/usecases/transaction/update_transaction.dart';

void main() {
  final transactionRepository = TransactionRepositoryImpl();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeNotifier(),      // ← DARK/LIGHT MODE BURADA
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionNotifier(
            addTransaction: AddTransaction(transactionRepository),
            deleteTransaction: DeleteTransaction(transactionRepository),
            getTransactions: GetTransactions(transactionRepository),
            updateTransaction: UpdateTransaction(transactionRepository),
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
      themeMode: themeNotifier.currentTheme,   // ← BURASI ARTIK DİNAMİK
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      home: const MainScreen(),
    );
  }
}
