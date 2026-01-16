import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';

class DateButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const DateButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = const Color(0xFF7BDE12);
    final primaryDarkColor = const Color(0xFF5FB30D);

    final inactiveText = isDark
        ? const Color(0xFFA0C47D)
        : const Color(0xFF749A4C);
    final inactiveBg = isDark ? const Color(0xFF253218) : Colors.white;
    final inactiveBorder = isDark
        ? const Color(0xFF2D3A1E)
        : const Color(0xFFE5E5E5);
    final inactiveShadow = Colors.black.withValues(alpha: 0.1);

    return PressableContainer(
      onPressed: onTap,
      pressOffset: 2.0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : inactiveBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.transparent : inactiveBorder,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected ? primaryDarkColor : inactiveShadow,
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          label.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : inactiveText,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
