import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/notifiers/ledger_notifier.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/top_bar.dart';
import 'package:harcama_app/presentation/widgets/ledger_dropdown.dart';
import 'package:harcama_app/presentation/widgets/balance_card.dart';
import 'package:harcama_app/presentation/widgets/transaction_list.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/transaction.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  bool showLedgerSheet = false;

  void _toggleLedgerSheet() {
    setState(() {
      showLedgerSheet = !showLedgerSheet;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final txNotifier = context.watch<TransactionNotifier>();
    final ledgerNotifier = context.watch<LedgerNotifier>();

    final activeLedgerId = ledgerNotifier.selectedLedger?.id;

    final visibleTx = activeLedgerId == null || activeLedgerId == 'default'
        ? txNotifier.transactions
        : txNotifier.transactions
              .where((t) => t.ledgerID == activeLedgerId)
              .toList();

    final income = visibleTx
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final expense = visibleTx
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final balance = income - expense;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: showLedgerSheet ? _toggleLedgerSheet : null,
              child: Column(
                children: [
                  TopBar(
                    isSearching: isSearching,
                    onSearchToggle: () =>
                        setState(() => isSearching = !isSearching),
                    onLedgerTap: _toggleLedgerSheet,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          if (!isSearching) ...[
                            BalanceCard(
                              balance: balance,
                              income: income,
                              expense: expense,
                            ),
                            const SizedBox(height: 24),
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.primaryCardShadow,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.zero,
                                  bottomRight: Radius.zero,
                                ),
                              ),
                            ),
                          ],
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(top: 24),
                              child: Column(
                                children: [
                                  TransactionList(
                                    transactions: visibleTx,
                                    notifier: txNotifier,
                                  ),
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showLedgerSheet)
              LedgerDropdown(
                isVisible: showLedgerSheet,
                ledgerNotifier: ledgerNotifier,
                onToggle: _toggleLedgerSheet,
              ),
          ],
        ),
      ),
    );
  }
}
