import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';

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
  final VoidCallback? onTap;
  final Widget? customTrailing;
  final double opacity;

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
    this.onTap,
    this.customTrailing,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Kart renkleri
    final cardColor = isDark ? AppColors.premiumCardDark : AppColors.cardLight;
    final borderColor = isDark ? AppColors.premiumCardBorderDark : AppColors.cardBorderLight;
    final shadowColor = isDark ? AppColors.cardBorder(context) : AppColors.cardShadowLight;

    Widget content = Opacity(
      opacity: opacity,
      child: Row(
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
      ),
    );

    // Eğer tıklanabilir değilse, sadece Container döndür (gölgesiz, bordersız veya isteğe bağlı)
    // Ama tutarlılık için tıklanabilir olmayanları da kart gibi gösterebiliriz.
    // Şimdilik tıklanabilir olmayanları da kart yapalım ama basma efekti olmasın.
    
    if (onTap == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: content,
      );
    }

    return PressableContainer(
      onPressed: onTap!,
      pressOffset: 4.0,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: content,
    );
  }
}
