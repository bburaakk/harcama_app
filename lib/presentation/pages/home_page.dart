import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:harcama_app/l10n/app_localizations.dart';

import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/notifiers/ledger_notifier.dart';
import 'package:harcama_app/presentation/notifiers/goal_notifier.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/top_bar.dart';
import 'package:harcama_app/presentation/widgets/ledger_dropdown.dart';
import 'package:harcama_app/presentation/widgets/remaining_balance_card.dart';
import 'package:harcama_app/presentation/widgets/transaction_list.dart';
import 'package:harcama_app/presentation/widgets/create_goal_dialog.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/pages/goal_page.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/domain/entities/goal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  bool showLedgerSheet = false;

  void _toggleLedgerSheet() {
    setState(() => showLedgerSheet = !showLedgerSheet);
  }

  @override
  Widget build(BuildContext context) {
    final txNotifier = context.watch<TransactionNotifier>();
    final ledgerNotifier = context.watch<LedgerNotifier>();
    final goalNotifier = context.watch<GoalNotifier>();
    final l10n = AppLocalizations.of(context)!;

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (showLedgerSheet) {
                  setState(() => showLedgerSheet = false);
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Column(
                  children: [
                    TopBar(
                      isSearching: isSearching,
                      onSearchToggle: () =>
                          setState(() => isSearching = !isSearching),
                      onLedgerTap: _toggleLedgerSheet,
                      searchHint: l10n.searchTransactions,
                      onSearchChanged: txNotifier.updateSearchQuery,
                      onSearchClear: () => txNotifier.updateSearchQuery(''),
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
                                children: [
                                  Text(
                                    l10n.yourGoals,
                                    style: TextStyle(
                                      color: AppColors.text(context),
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const GoalPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      l10n.seeAll,
                                      style: TextStyle(
                                        color: AppColors.primaryDark,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 200, // Increased height to prevent clipping
                                child: GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 16), // Bottom padding
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 24,
                                        mainAxisSpacing: 12,
                                        mainAxisExtent: 80,
                                      ),
                                  itemCount: goalNotifier.goals.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == goalNotifier.goals.length) {
                                      return _addGoalCard(context);
                                    }
                                    return _goalCard(
                                      context: context,
                                      goal: goalNotifier.goals[index],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  l10n.recentActivity,
                                  style: TextStyle(
                                    color: AppColors.text(context),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
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

  Widget _goalCard({required BuildContext context, required Goal goal}) {
    final iconMap = {
      '🏖️': Symbols.beach_access_rounded,
      '🛡️': Symbols.shield_with_heart_rounded,
      '💻': Symbols.laptop_mac_rounded,
      '🚗': Symbols.directions_car_rounded,
      '🏠': Symbols.home_rounded,
      '🎯': Symbols.target_rounded,
    };

    final colorMap = {
      'orange': AppColors.secondaryYellow,
      'blue': AppColors.secondaryBlue,
      'purple': AppColors.primary,
      'green': AppColors.primary,
      'red': Colors.red,
      'yellow': AppColors.secondaryYellow,
    };

    final iconData = iconMap[goal.icon] ?? Symbols.target_rounded;
    final color = colorMap[goal.color] ?? AppColors.primary;
    final colorDark = color == AppColors.primary
        ? AppColors.primaryDark
        : color == AppColors.secondaryYellow
        ? AppColors.secondaryYellowDark
        : color == AppColors.secondaryBlue
        ? AppColors.secondaryBlueDark
        : color;

    return PressableContainer(
      onPressed: () {},
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.card(context),
        border: Border.all(color: AppColors.cardBorder(context), width: 2),
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.cardBorder(context), // Changed to cardBorder for consistent shadow
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(iconData, color: colorDark, size: 20, weight: 700),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    goal.title.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.subtitleText(context),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "₺${goal.currentAmount.toStringAsFixed(0)}/₺${goal.targetAmount.toStringAsFixed(0)}",
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.progressBackground(context),
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: goal.progress,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addGoalCard(BuildContext context) {
    return PressableContainer(
      onPressed: () async {
        final result = await showDialog<Goal>(
          context: context,
          builder: (_) => const CreateGoalDialog(),
        );

        if (result != null) {
          context.read<GoalNotifier>().addItem(result);
        }
      },
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.progressBackground(context).withOpacity(0.5),
        border: Border.all(color: AppColors.cardBorder(context), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_outline,
            color: AppColors.subtitleText(context),
            size: 28,
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context)!.newGoal,
            style: TextStyle(
              color: AppColors.subtitleText(context),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
