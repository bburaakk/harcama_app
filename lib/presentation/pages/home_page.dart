import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notifier = context.watch<TransactionNotifier>();

    final income = notifier.transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final expense = notifier.transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final balance = income - expense;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    if (!isSearching) ...[
                      _heroCard(context, balance, income, expense),
                      const SizedBox(height: 20),
                      _insights(context, notifier),
                      const SizedBox(height: 24),
                    ],

                    _transactions(context, notifier),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TOP BAR WITH SEARCH
  Widget _topBar(BuildContext context) {
    final notifier = context.read<TransactionNotifier>();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isSearching
            ? Row(
                key: const ValueKey('search'),
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: "Search transactions...",
                        border: InputBorder.none,
                      ),
                      onChanged: notifier.updateSearchQuery,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      notifier.updateSearchQuery('');
                      setState(() => isSearching = false);
                    },
                  ),
                ],
              )
            : Row(
                key: const ValueKey('normal'),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 20),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome back",
                            style: theme.textTheme.labelSmall,
                          ),
                          Text(
                            "Alex Morgan",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() => isSearching = true);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  // HERO CARD
  Widget _heroCard(
    BuildContext context,
    double balance,
    double income,
    double expense,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: isDark ? const Color(0xFF1A2C26) : Colors.white,
      ),
      child: Column(
        children: [
          const Text("Total Balance"),
          const SizedBox(height: 6),
          Text(
            "₺${balance.toStringAsFixed(2)}",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _miniStat(
                context,
                icon: Icons.arrow_downward,
                label: "Income",
                value: income,
                color: Colors.green,
              ),
              const SizedBox(width: 12),
              _miniStat(
                context,
                icon: Icons.arrow_upward,
                label: "Expenses",
                value: expense,
                color: Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(
    BuildContext context, {
    required IconData icon,
    required String label,
    required double value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color.withOpacity(0.12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 6),
            Text(label),
            Text(
              "₺${value.toStringAsFixed(0)}",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // INSIGHTS
  Widget _insights(BuildContext context, TransactionNotifier notifier) {
    final now = DateTime.now();
    final theme = Theme.of(context);

    final mostExpensive = notifier.getMostExpensiveCategoryInfo(now.month, now.year);

    final budgetInfo = notifier.getBudgetOverview(now.month, now.year);
    final dailyAvailable = budgetInfo['dailyAvailable'] as double;
    final remainingBudget = budgetInfo['remaining'] as double;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 140,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: theme.cardColor,
            ),
            child: mostExpensive == null
                ? Center(
                    child: Text(
                      "No expenses\nthis month",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.trending_up,
                                color: Colors.red, size: 20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Top Spending",
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mostExpensive['category'].title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "₺${(mostExpensive['amount'] as double).toStringAsFixed(0)}",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(width: 12),
        
        // Daily Budget Limit Card
        Expanded(
          child: GestureDetector(
            onTap: () => _showBudgetDialog(context, notifier),
            child: Container(
              height: 140,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: const Color(0xFFE0F7FA),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.cyan.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.savings_outlined,
                                color: Colors.cyan, size: 20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Daily Limit",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.cyan[900],
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.edit, size: 16, color: Colors.cyan[900]),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (remainingBudget < 0)
                         Text(
                          "Over Budget!",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        )
                      else
                        Text(
                          "₺${dailyAvailable.toStringAsFixed(0)}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.cyan[900],
                          ),
                        ),
                      
                      const SizedBox(height: 4),
                      Text(
                        remainingBudget < 0 
                          ? "₺${remainingBudget.abs().toStringAsFixed(0)} excess"
                          : "left for ${budgetInfo['daysLeft']} days",
                        style: theme.textTheme.labelSmall?.copyWith(
                           color: remainingBudget < 0 ? Colors.red : Colors.cyan[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showBudgetDialog(BuildContext context, TransactionNotifier notifier) {
    final controller = TextEditingController(
      text: notifier.monthlyBudget.toStringAsFixed(0)
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Set Monthly Budget"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: "Budget Amount",
            prefixText: "₺",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null) {
                notifier.setMonthlyBudget(amount);
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // TRANSACTIONS LIST
  Widget _transactions(
    BuildContext context,
    TransactionNotifier notifier,
  ) {
    final dateFormat = DateFormat('dd MMM, HH:mm');

    if (notifier.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(),
      );
    }

    if (notifier.transactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Text("No transactions found"),
      );
    }

    return Column(
      children: notifier.transactions.map((t) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).cardColor,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                child: Text(
                  t.category?.icon ?? _fallbackIcon(t.type),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dateFormat.format(t.entryDate),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
              Text(
                "${t.type == TransactionType.expense ? "-" : "+"}₺${t.amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: t.type == TransactionType.expense
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _fallbackIcon(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return "💸";
      case TransactionType.income:
        return "💰";
      case TransactionType.transfer:
        return "🔁";
    }
  }
}
