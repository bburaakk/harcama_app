import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // ← DARK/LIGHT TEMA
    final isDark = theme.brightness == Brightness.dark;

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
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onSurface,
        title: Text(
          "Harcamalar",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.calendar_month), onPressed: () {}),
        ],
      ),

      body: Column(
        children: [
          // TOP SUMMARY CARD
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? Colors.green.withOpacity(0.2) : Colors.green.shade100,
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.green.shade200.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Gelir: ₺${income.toStringAsFixed(2)}"),
                    Text("Gider: ₺${expense.toStringAsFixed(2)}"),
                    Text("Bakiye: ₺${balance.toStringAsFixed(2)}"),
                  ],
                ),
              ),
            ),
          ),

          // QUICK CARDS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _quickCard(
                    context,
                    color: isDark ? Colors.blue.withOpacity(0.25) : Colors.blue.shade100,
                    shadow: Colors.blue,
                    label: "🏆 En Çok Harcama",
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _quickCard(
                    context,
                    color: isDark ? Colors.orange.withOpacity(0.25) : Colors.orange.shade100,
                    shadow: Colors.orange,
                    label: "💰 Tasarruf Oranı",
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // LIST
          Expanded(
            child: notifier.isLoading
                ? const Center(child: CircularProgressIndicator())
                : notifier.transactions.isEmpty
                    ? Center(
                        child: Text(
                          "Henüz işlem yok",
                          style: TextStyle(
                            fontSize: 16,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: notifier.transactions.length,
                        itemBuilder: (context, index) {
                          final t = notifier.transactions[index];
                          final iconEmoji =
                              t.category?.icon ?? _fallbackIcon(t.type);
                          final dateFormat = DateFormat('dd/MM/yyyy');

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                if (!isDark)
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              leading: Text(
                                iconEmoji,
                                style: const TextStyle(fontSize: 28),
                              ),
                              title: Text(
                                t.title,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              subtitle: Text(
                                "₺${t.amount.toStringAsFixed(2)} (${dateFormat.format(t.entryDate)})",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    notifier.deleteItem(t.id),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _quickCard(
    BuildContext context, {
    required Color color,
    required Color shadow,
    required String label,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: shadow.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
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
