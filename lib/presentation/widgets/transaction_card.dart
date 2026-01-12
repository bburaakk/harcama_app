import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/pages/expense_detail.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
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
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.black.withOpacity(0.3),
          width: 4,
        ),
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : AppColors.primaryCardColor,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.10),
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
        const BoxShadow(
          color: AppColors.primaryCardShadow,
          offset: Offset(0, 10),
        ),
      ],
      child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Text(
                    t.category?.icon ?? _fallbackIcon(t.type),
                    style: const TextStyle(fontSize: 28),
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
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateFormat.format(t.entryDate),
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 50,
              child: Center(
                child: Icon(
                  typeIcon,
                  size: 42,
                  weight: 700,
                  opticalSize: 20,
                  grade: 200,
                  color: typeColor,
                ),
              ),
            ),

            SizedBox(
              width: 110,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${t.type == TransactionType.expense ? "-" : "+"}₺${t.amount.toStringAsFixed(2)}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: Colors.white,
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
