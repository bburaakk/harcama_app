import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';

class DailyGoalCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double current;
  final double target;
  final Color color;
  final Color colorDark;
  final VoidCallback? onPressed;

  const DailyGoalCard({
    super.key,
    required this.icon,
    required this.label,
    required this.current,
    required this.target,
    required this.color,
    required this.colorDark,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (current / target).clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PressableContainer(
      onPressed: onPressed ?? () {},
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.card(context),
        border: Border.all(
          color: AppColors.cardBorder(context),
          width: 2,
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.cardShadow(context),
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: colorDark,
                  size: 20,
                  weight: 700,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.subtitleText(context),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "₺${current.toStringAsFixed(0)}/${target.toStringAsFixed(0)}",
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.progressBackground(context),
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddGoalCard extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddGoalCard({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: AppColors.progressBackground(context).withOpacity(0.5),
          border: Border.all(
            color: AppColors.cardBorder(context),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_circle_outline,
              color: AppColors.subtitleText(context),
              size: 28,
            ),
            const SizedBox(height: 6),
            Text(
              "New Goal",
              style: TextStyle(
                color: AppColors.subtitleText(context),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
