import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int pageIndex;
  final Function(int) onTap;

  const NavBar({super.key, required this.pageIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.green,
      child: Row(
        children: [
          navItem(Icons.home, pageIndex == 0, onTap: () => onTap(0)),
          navItem(Icons.bar_chart, pageIndex == 1, onTap: () => onTap(1)),
          const SizedBox(width: 80),
          navItem(Icons.assignment, pageIndex == 2, onTap: () => onTap(2)),
          navItem(Icons.person_outline, pageIndex == 3, onTap: () => onTap(3)),
        ],
      ),
    );
  }

  Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: selected ? Colors.white : Colors.white.withOpacity(0.4),
        ),
      ),
    );
  }
}
