import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';

class StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;

  const StatBox({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PressableContainer(
        onPressed: () => {},
        padding: const EdgeInsets.symmetric(vertical: AppColors.statBoxPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppColors.statBoxBorderRadius),
          color: AppColors.statBoxColor,
          border: Border.all(
            color: Colors.black.withOpacity(0.3),
            width: 4,
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.statBoxShadow,
            offset: AppColors.statBoxShadowOffset,
          ),
        ],
        child: Column(
          children: [
            Icon(icon, size: 22, color: AppColors.primaryTextOnCard),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryTextOnCard,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "₺${value.toStringAsFixed(0)}",
              style: const TextStyle(
                color: AppColors.primaryTextOnCard,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
