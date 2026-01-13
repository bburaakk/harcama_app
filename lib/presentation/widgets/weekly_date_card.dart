import 'package:flutter/material.dart';

class WeeklyDateCard extends StatelessWidget {
  final String year;
  final String weekNumber;
  final String dateRange;
  final bool isSelected;
  final VoidCallback onTap;

  const WeeklyDateCard({
    super.key,
    required this.year,
    required this.weekNumber,
    required this.dateRange,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF7BDE12)
              : (isDark ? const Color(0xFF253218) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? const Color(0xFF2D3A1E) : const Color(0xFFE5E5E5)),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFF5FB30D)
                  : Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // SOL TARAF: Hafta bilgisi
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  weekNumber,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark
                              ? const Color(0xFFA0C47D)
                              : const Color(0xFF749A4C)),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dateRange,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.9)
                        : (isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // SAĞ TARAF: Yıl
            Text(
              year,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark
                          ? const Color(0xFFA0C47D)
                          : const Color(0xFF749A4C)),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
