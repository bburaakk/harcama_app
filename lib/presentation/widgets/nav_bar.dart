import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';

class NavBar extends StatelessWidget {
  final int index;
  final Function(int) onTap;

  const NavBar({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 70 + bottomPadding,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: bottomPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryCardColor,
        border: Border(
          top: BorderSide(
            color: Colors.black.withOpacity(0.3),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryCardShadow.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _item(icon: Icons.home, i: 0),
          _item(icon: Icons.pie_chart, i: 1),

          const SizedBox(width: 80),

          _item(icon: Icons.account_balance_wallet, i: 2),
          _item(icon: Icons.person, i: 3),
        ],
      ),
    );
  }

  Widget _item({required IconData icon, required int i}) {
    final selected = index == i;

    return GestureDetector(
      onTap: () => onTap(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: selected ? 26 : 24,
          color: Colors.white,
        ),
      ),
    );
  }
}
