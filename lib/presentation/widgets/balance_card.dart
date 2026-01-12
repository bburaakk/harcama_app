import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/widgets/stat_box.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';

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
    return PressableContainer(
      onPressed: () {
        // TODO: Add functionality
      },
      padding: const EdgeInsets.all(AppColors.cardPadding),
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
            "Total Balance",
            style: TextStyle(
              color: AppColors.primaryTextOnCard.withOpacity(0.9),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "₺${balance.toStringAsFixed(2)}",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryTextOnCard,
                  fontSize: 38,
                ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: Row(
              children: [
                StatBox(
                  icon: Icons.arrow_downward,
                  label: "Income",
                  value: income,
                ),
                const SizedBox(width: 12),
                StatBox(
                  icon: Icons.arrow_upward,
                  label: "Expenses",
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
