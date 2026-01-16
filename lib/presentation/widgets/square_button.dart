import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';

class SquareButton extends StatefulWidget {
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
  State<SquareButton> createState() => _SquareButtonState();
}

class _SquareButtonState extends State<SquareButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Use cardBorder color for shadow in dark mode to match HomePage style
    final effectiveShadows = widget.isDark
        ? [
            BoxShadow(
              color: AppColors.cardBorder(context),
              offset: const Offset(0, 4),
              blurRadius: 0,
            )
          ]
        : widget.shadows;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () {
        if (mounted) setState(() => _isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 44,
        height: 44,
        transform: Matrix4.translationValues(0, _isPressed ? 4 : 0, 0),
        decoration: BoxDecoration(
          color: widget.bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            top: BorderSide(color: widget.borderColor, width: 2),
            left: BorderSide(color: widget.borderColor, width: 2),
            right: BorderSide(color: widget.borderColor, width: 2),
            bottom: BorderSide(color: widget.borderColor, width: 4),
          ),
          boxShadow: _isPressed ? [] : effectiveShadows,
        ),
        child: Center(
          child: Icon(
            widget.icon,
            color: widget.isDark ? Colors.grey[300] : Colors.grey[600],
            size: 20,
          ),
        ),
      ),
    );
  }
}
