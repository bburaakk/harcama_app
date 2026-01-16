import 'package:flutter/material.dart';

class UsageBar extends StatelessWidget {
  final String label;
  final String value;
  final double percentage;
  final Color progressColor;
  final bool isDark;

  const UsageBar({
    super.key,
    required this.label,
    required this.value,
    required this.percentage,
    required this.progressColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xFF151B0D),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey[500],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[100],
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[200]!, width: 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
