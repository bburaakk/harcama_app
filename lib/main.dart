import 'package:flutter/material.dart';
import 'package:harcama_app/data/repositories/expenses_repository_impl.dart';
import 'package:harcama_app/presentation/notifiers/expense_notifier.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/presentation/pages/main_screen.dart';
import 'package:harcama_app/domain/usecases/expense/add_expense.dart';
import 'package:harcama_app/domain/usecases/expense/delete_expense.dart';
import 'package:harcama_app/domain/usecases/expense/get_expenses.dart';
import 'package:harcama_app/domain/usecases/expense/update_expense.dart';

void main() {
  final expenseRepository = ExpenseRepositoryImpl();

  final addExpense = AddExpense(expenseRepository);
  final deleteExpense = DeleteExpense(expenseRepository);
  final getExpenses = GetExpenses(expenseRepository);
  final updateExpense = UpdateExpense(expenseRepository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ExpenseNotifier(
        addExpense: addExpense,
        deleteExpense: deleteExpense,
        getExpenses: getExpenses,
        updateExpense: updateExpense,
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
