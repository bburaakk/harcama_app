import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';

class ChartHeader extends StatelessWidget {
  const ChartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Center(
        child: Text(
          'Spending Insights',
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
