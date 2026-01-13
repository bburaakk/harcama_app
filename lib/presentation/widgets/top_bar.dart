import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';

class TopBar extends StatelessWidget {
  final bool isSearching;
  final VoidCallback onSearchToggle;
  final VoidCallback onLedgerTap;

  const TopBar({
    super.key,
    required this.isSearching,
    required this.onSearchToggle,
    required this.onLedgerTap,
  });

  @override
  Widget build(BuildContext context) {
    final txNotifier = context.read<TransactionNotifier>();
    final iconColor = AppColors.subtitleText(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isSearching
            ? Row(
                key: const ValueKey('search'),
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      style: TextStyle(color: AppColors.text(context)),
                      decoration: InputDecoration(
                        hintText: "Search transactions...",
                        hintStyle: TextStyle(color: AppColors.subtitleText(context)),
                        border: InputBorder.none,
                      ),
                      onChanged: txNotifier.updateSearchQuery,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Symbols.close_rounded, color: iconColor),
                    onPressed: () {
                      txNotifier.updateSearchQuery('');
                      onSearchToggle();
                    },
                  ),
                ],
              )
            : Row(
                key: const ValueKey('normal'),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Ledger Menu Button
                  GestureDetector(
                    onTap: onLedgerTap,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.primaryDark.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryDark.withOpacity(0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Symbols.menu_book_rounded,
                        color: Colors.white,
                        size: 24,
                        weight: 700,
                      ),
                    ),
                  ),
                  
                  // Right Side Buttons
                  Row(
                    children: [
                      _buildSquareButton(
                        context,
                        icon: Symbols.search_rounded,
                        onTap: onSearchToggle,
                      ),
                      const SizedBox(width: 10),
                      _buildSquareButton(
                        context,
                        icon: Symbols.calendar_today_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSquareButton(BuildContext context, {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.cardBorder(context),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardBorder(context),
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: AppColors.subtitleText(context),
          size: 24,
          weight: 600,
        ),
      ),
    );
  }
}
