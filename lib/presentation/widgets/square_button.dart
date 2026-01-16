import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';

class SquareButton extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color borderColor;
  final List<BoxShadow> shadows;
  final bool isDark;
  final VoidCallback onTap;

  const SquareButton({
    super.key,
    required this.icon,
    required this.bgColor,
    required this.borderColor,
    required this.shadows,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressableContainer(
      onPressed: onTap,
      pressOffset: 4.0,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          top: BorderSide(color: borderColor, width: 2),
          left: BorderSide(color: borderColor, width: 2),
          right: BorderSide(color: borderColor, width: 2),
          bottom: BorderSide(color: borderColor, width: 4),
        ),
        boxShadow: shadows,
      ),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(icon, color: isDark ? Colors.grey[300] : Colors.grey[600], size: 20),
      ),
    );
  }
}
