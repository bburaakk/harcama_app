import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int index;
  final Function(int) onTap;

  const NavBar({super.key, required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          item(icon: Icons.home, i: 0),
          item(icon: Icons.bar_chart, i: 1),
          const SizedBox(width: 50),
          item(icon: Icons.assignment, i: 2),
          item(icon: Icons.person_outline, i: 3),
        ],
      ),
    );
  }

  Widget item({required IconData icon, required int i}) {
    final selected = index == i;
    return GestureDetector(
      onTap: () => onTap(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: selected ? 30 : 26,
              color: selected ? Colors.green : Colors.black26,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(top: 4),
              height: 6,
              width: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.green : Colors.transparent,
              ),
            )
          ],
        ),
      ),
    );
  }
}
