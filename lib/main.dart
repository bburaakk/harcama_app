import 'package:flutter/material.dart';
import 'package:harcama_app/data/repositories/transaction_repository_impl.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/presentation/pages/main_screen.dart';
import 'package:harcama_app/domain/usecases/transaction/add_transaction.dart';
import 'package:harcama_app/domain/usecases/transaction/delete_transaction.dart';
import 'package:harcama_app/domain/usecases/transaction/get_transactions.dart';
import 'package:harcama_app/domain/usecases/transaction/update_transaction.dart';

void main() {
  final transactionRepository = TransactionRepositoryImpl();

  final addTransaction = AddTransaction(transactionRepository);
  final deleteTransaction = DeleteTransaction(transactionRepository);
  final getTransactions = GetTransactions(transactionRepository);
  final updateTransaction = UpdateTransaction(transactionRepository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => TransactionNotifier(
        addTransaction: addTransaction,
        deleteTransaction: deleteTransaction,
        getTransactions: getTransactions,
        updateTransaction: updateTransaction,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
      ),
      home: const MainScreen(),
    );
  }
}
