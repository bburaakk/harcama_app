import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/pages/expense_detail.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/domain/utility/currency_helper.dart';
import 'package:harcama_app/presentation/notifiers/currency_notifier.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class TransactionCard extends StatelessWidget {
  final Transaction t;
  final bool isDark;
  final DateFormat dateFormat;

  const TransactionCard({
    super.key,
    required this.t,
    required this.isDark,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    final currencySymbol = context.watch<CurrencyNotifier>().currencySymbol;
    IconData typeIcon;
    Color typeColor;

    switch (t.type) {
      case TransactionType.income:
        typeIcon = Symbols.arrow_downward_rounded;
        typeColor = Colors.greenAccent;
        break;
      case TransactionType.expense:
        typeIcon = Symbols.arrow_upward_rounded;
        typeColor = Colors.redAccent;
        break;
      case TransactionType.transfer:
        typeIcon = Symbols.swap_horiz_rounded;
        typeColor = Colors.blueAccent;
        break;
    }

    return PressableContainer(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => ExpenseDetailPage(transaction: t),
          ),
        );
      },
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.cardBorder(context),
          width: 2,
        ),
        color: AppColors.card(context),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.cardBorder(context), // Changed to cardBorder for consistent shadow
          offset: const Offset(0, 4),
        ),
      ],
      child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    t.category?.icon ?? _fallbackIcon(t.type),
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: AppColors.text(context),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dateFormat.format(t.entryDate),
                          style: TextStyle(
                            color: AppColors.subtitleText(context),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 40,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: typeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    typeIcon,
                    size: 18,
                    weight: 700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(
              width: 100,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${t.type == TransactionType.expense ? "-" : "+"}$currencySymbol${CurrencyHelper.format(t.amount)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: t.type == TransactionType.expense 
                        ? AppColors.expenseColor(context) 
                        : AppColors.primaryDark,
                  ),
                ),
              ),
            ),
          ],
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
