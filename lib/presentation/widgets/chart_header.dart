import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/l10n/app_localizations.dart';

class ChartHeader extends StatelessWidget {
  const ChartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Center(
        child: Text(
          l10n.spendingInsights,
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
