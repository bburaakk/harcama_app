import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Color? color;

  const SectionHeader({
    super.key,
    required this.title,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 14,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
