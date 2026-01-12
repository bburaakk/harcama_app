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
        borderRadius: BorderRadius.circular(AppColors.cardBorderRadius),
        border: Border.all(
          color: Colors.black.withOpacity(0.3),
          width: 4,
        ),
        color: AppColors.primaryCardColor,
      ),
      boxShadow: const [
        BoxShadow(
          color: AppColors.primaryCardShadow,
          offset: AppColors.cardShadowOffset,
        ),
      ],
      child: const SizedBox(
        height: 70,
        width: 70,
        child: Center(
          child: Icon(
            Symbols.add_rounded,
            size: 42,
            weight: 700,
            opticalSize: 20,
            grade: 200,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
