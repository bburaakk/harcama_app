import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

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
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.gray200,
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gray200,
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _item(
            icon: Symbols.home_rounded,
            i: 0,
          ), 
          _item(
            icon: Symbols.pie_chart_rounded,
            i: 1,
          ),

          const SizedBox(width: 80),

          _item(
            icon: Symbols.account_balance_wallet_rounded,
            i: 2,
          ),
          _item(
            icon: Symbols.person_rounded,
            i: 3,
          ),
        ],
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required int i,
  }) {
    final selected = index == i;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(i),
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: Icon(
          icon,
          fill: selected ? 1 : 0,
          size: selected ? 30 : 24,
          weight: 700,
          grade: 200,
          color: selected ? AppColors.primary : AppColors.gray400,
        ),
      ),
    );
  }
}
