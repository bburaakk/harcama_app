import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/pages/add_transaction_page.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:material_symbols_icons/symbols.dart';

class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return PressableContainer(
      onPressed: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) =>
                AddTransactionPage(),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: animation.drive(
                  Tween(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeOut)),
                ),
                child: child,
              );
            },
          ),
        );
      },
      margin: EdgeInsets.only(bottom: 20 + bottomPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.secondaryBlue,
      ),
      boxShadow: const [
        BoxShadow(
          color: AppColors.secondaryBlueDark,
          offset: Offset(0, 4),
        ),
      ],
      child: const SizedBox(
        height: 64,
        width: 64,
        child: Center(
          child: Icon(
            Symbols.add_rounded,
            size: 36,
            weight: 700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
