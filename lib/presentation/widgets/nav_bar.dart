import 'package:flutter/material.dart';

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

    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.97),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _item(icon: Icons.home, i: 0),
          _item(icon: Icons.pie_chart, i: 1),

          const SizedBox(width: 64),

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
          color: selected ? Colors.green.withOpacity(0.15) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: selected ? 26 : 24,
          color: selected ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
