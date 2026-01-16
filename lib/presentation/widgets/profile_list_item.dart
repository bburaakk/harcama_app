import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';

class ProfileListItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final Color textColor;
  final Color? subTextColor;
  final IconData? trailingIcon;
  final Color? trailingIconColor;
  final bool isLast;
  final Color borderColor;
  final VoidCallback? onTap;
  final Widget? customTrailing;

  const ProfileListItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    this.subtitle,
    this.subtitleWidget,
    required this.textColor,
    this.subTextColor,
    this.trailingIcon,
    this.trailingIconColor,
    this.isLast = false,
    this.borderColor = Colors.grey,
    this.onTap,
    this.customTrailing,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: iconColor.withOpacity(0.2), width: 2),
          ),
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              if (subtitleWidget != null)
                subtitleWidget!
              else if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: subTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        if (customTrailing != null)
          customTrailing!
        else if (onTap != null)
          Icon(trailingIcon ?? Icons.chevron_right, color: trailingIconColor ?? Colors.grey[300])
        else if (trailingIcon != null)
          Icon(trailingIcon, color: trailingIconColor ?? Colors.grey[300]),
      ],
    );

    if (onTap == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: isLast ? null : Border(bottom: BorderSide(color: borderColor, width: 2)),
        ),
        child: content,
      );
    }

    return PressableContainer(
      onPressed: onTap!,
      pressOffset: 2.0,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: isLast ? null : Border(bottom: BorderSide(color: borderColor, width: 2)),
      ),
      child: content,
    );
  }
}
