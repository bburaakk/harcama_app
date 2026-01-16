import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/widgets/transaction_card.dart';
import 'package:intl/intl.dart';
import 'package:harcama_app/l10n/app_localizations.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final TransactionNotifier notifier;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM, HH:mm');
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (notifier.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(),
      );
    }

    if (transactions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Text(AppLocalizations.of(context)!.noTransactionsFound),
      );
    }

    return Column(
      children: transactions.reversed.map((t) {
        return TransactionCard(t: t, isDark: isDark, dateFormat: dateFormat);
      }).toList(),
    );
  }
}
