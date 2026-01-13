import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/domain/utility/currency_helper.dart';
import 'package:intl/intl.dart';

class TopExpensesList extends StatelessWidget {
  final List<Transaction> transactions;

  const TopExpensesList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final expenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final top10 = expenses.take(10).toList();

    if (top10.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Top Expenses',
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: top10.map((tx) => _buildExpenseItem(context, tx)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseItem(BuildContext context, Transaction tx) {
    final dateFormat = DateFormat('MMM d, yyyy');

    String iconString = tx.category?.icon ?? '';
    Widget iconWidget;

    if (iconString.isNotEmpty) {
      final int? codePoint = int.tryParse(iconString);
      if (codePoint != null) {
        iconWidget = Icon(
          IconData(codePoint, fontFamily: 'MaterialIcons'),
          color: AppColors.primary,
          size: 24,
        );
      } else if (iconString.length <= 2) {
        iconWidget = Text(iconString, style: const TextStyle(fontSize: 24));
      } else {
        iconWidget = Icon(Icons.category, color: AppColors.primary, size: 24);
      }
    } else {
      iconWidget = Icon(Icons.category, color: AppColors.primary, size: 24);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder(context), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(child: iconWidget),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title.isNotEmpty ? tx.title : (tx.category?.title ?? 'Expense'),
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  dateFormat.format(tx.date),
                  style: TextStyle(
                    color: AppColors.subtitleText(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '-₺${CurrencyHelper.format(tx.amount)}',
            style: TextStyle(
              color: AppColors.expenseColor(context),
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
