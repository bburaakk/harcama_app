import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/notifiers/ledger_notifier.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/top_bar.dart';
import 'package:harcama_app/presentation/widgets/ledger_dropdown.dart';
import 'package:harcama_app/presentation/widgets/remaining_balance_card.dart';
import 'package:harcama_app/presentation/widgets/daily_goal_card.dart';
import 'package:harcama_app/presentation/widgets/transaction_list.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:material_symbols_icons/symbols.dart';

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
                            RemainingBalanceCard(balance: balance),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  "Daily Goals",
                                  style: TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  "See All",
                                  style: TextStyle(
                                    color: AppColors.primaryDark,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.1,
                              children: [
                                DailyGoalCard(
                                  icon: Symbols.restaurant_rounded,
                                  label: "Food",
                                  current: 12,
                                  target: 20,
                                  color: AppColors.secondaryYellow,
                                  colorDark: AppColors.secondaryYellowDark,
                                ),
                                DailyGoalCard(
                                  icon: Symbols.directions_car_rounded,
                                  label: "Travel",
                                  current: 5,
                                  target: 15,
                                  color: AppColors.secondaryBlue,
                                  colorDark: AppColors.secondaryBlueDark,
                                ),
                                DailyGoalCard(
                                  icon: Symbols.confirmation_number_rounded,
                                  label: "Fun",
                                  current: 8,
                                  target: 10,
                                  color: AppColors.primary,
                                  colorDark: AppColors.primaryDark,
                                ),
                                const AddGoalCard(),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                const Text(
                                  "Recent Activity",
                                  style: TextStyle(
                                    color: AppColors.textDark,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],
                          Expanded(
                            child: SingleChildScrollView(
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
