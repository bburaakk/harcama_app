import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:provider/provider.dart';

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
    final iconColor = AppColors.text(context);

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
                    icon: Icon(Icons.close, color: iconColor),
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
                  IconButton(
                    icon: Icon(Icons.account_balance_wallet_outlined, color: iconColor),
                    iconSize: 28,
                    onPressed: onLedgerTap,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.search, size: 26, color: iconColor),
                        onPressed: onSearchToggle,
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications_outlined, size: 26, color: iconColor),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
