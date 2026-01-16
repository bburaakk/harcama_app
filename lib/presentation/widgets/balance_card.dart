import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/widgets/stat_box.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/l10n/app_localizations.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return PressableContainer(
      onPressed: () {
        // TODO: Add functionality
      },
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppColors.cardBorderRadius),
        border: Border.all(
            color: Colors.black.withOpacity(0.3),
            width: 4,
          ),
        color: AppColors.primaryCardColor,
      ),
      boxShadow: const [
        BoxShadow(
          color: AppColors.primaryCardShadow,
          offset: AppColors.cardShadowOffset,
        ),
      ],
      child: Column(
        children: [
          Text(
            l10n.totalBalance,
            style: TextStyle(
              color: AppColors.primaryTextOnCard.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "₺${balance.toStringAsFixed(2)}",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryTextOnCard,
                  fontSize: 32,
                ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: Row(
              children: [
                StatBox(
                  icon: Icons.arrow_downward,
                  label: l10n.incomeLabel,
                  value: income,
                ),
                const SizedBox(width: 12),
                StatBox(
                  icon: Icons.arrow_upward,
                  label: l10n.expensesLabel,
                  value: expense,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
