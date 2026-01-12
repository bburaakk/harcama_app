import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
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
                      decoration: const InputDecoration(
                        hintText: "Search transactions...",
                        border: InputBorder.none,
                      ),
                      onChanged: txNotifier.updateSearchQuery,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
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
                    icon: const Icon(Icons.account_balance_wallet_outlined),
                    iconSize: 28,
                    onPressed: onLedgerTap,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, size: 26),
                        onPressed: onSearchToggle,
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, size: 26),
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
