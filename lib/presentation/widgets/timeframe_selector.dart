import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';

class TimeframeSelector extends StatelessWidget {
  final int selectedIndex;
  final List<String> timeframes;
  final ValueChanged<int> onTimeframeSelected;

  const TimeframeSelector({
    super.key,
    required this.selectedIndex,
    required this.timeframes,
    required this.onTimeframeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(16),
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
          children: timeframes.asMap().entries.map((entry) {
            final index = entry.key;
            final timeframe = entry.value;
            final isSelected = selectedIndex == index;

            return Expanded(
              child: PressableContainer(
                onPressed: () => onTimeframeSelected(index),
                pressOffset: 2.0,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          const BoxShadow(
                            color: AppColors.primaryDark,
                            offset: Offset(0, 4),
                            blurRadius: 0,
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    timeframe.toUpperCase(),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.grayDark400 : const Color(0xFF749A4C)),
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
