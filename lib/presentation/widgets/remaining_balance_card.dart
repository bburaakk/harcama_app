import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/domain/utility/currency_helper.dart';
import 'package:material_symbols_icons/symbols.dart';

class RemainingBalanceCard extends StatelessWidget {
  final double balance;

  const RemainingBalanceCard({
    super.key,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return PressableContainer(
      onPressed: () {
        // TODO: Add functionality
      },
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.primary,
      ),
      boxShadow: const [
        BoxShadow(
          color: AppColors.primaryDark,
          offset: Offset(0, 4),
        ),
      ],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "REMAINING BALANCE",
                style: TextStyle(
                  color: AppColors.textDark.withOpacity(0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "₺${CurrencyHelper.format(balance)}",
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Symbols.account_balance_wallet_rounded,
              size: 36,
              color: AppColors.textDark,
              weight: 700,
            ),
          ),
        ],
      ),
    );
  }
}
