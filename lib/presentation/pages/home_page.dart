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
import 'package:intl/intl.dart';

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

  void _showCalendar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _CalendarSheet(),
    );
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

    List<Transaction> listTransactions = visibleTx;
    if (txNotifier.filterDateRange == null && !isSearching) {
      final now = DateTime.now();
      listTransactions = visibleTx.where((t) => 
        t.date.year == now.year && t.date.month == now.month
      ).toList();
    }

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
                      onCalendarTap: () => _showCalendar(context),
                      searchHint: l10n.searchTransactions,
                      onSearchChanged: txNotifier.updateSearchQuery,
                      onSearchClear: () {
                        txNotifier.updateSearchQuery('');
                        txNotifier.setFilterType(null);
                        txNotifier.setFilterCategory(null);
                        txNotifier.setFilterLedger(null);
                        txNotifier.setFilterAccount(null);
                        txNotifier.setFilterDateRange(null);
                      },
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
                                      transactions: listTransactions,
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
            
            // Overlay for closing dropdown
            if (showLedgerSheet)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => setState(() => showLedgerSheet = false),
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    color: Colors.transparent,
                  ),
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

class _CalendarSheet extends StatefulWidget {
  const _CalendarSheet();

  @override
  State<_CalendarSheet> createState() => _CalendarSheetState();
}

class _CalendarSheetState extends State<_CalendarSheet> {
  late PageController _pageController;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final int _initialPage = 1200;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _getDateFromIndex(int index) {
    final now = DateTime.now();
    return DateTime(now.year, now.month + (index - _initialPage));
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final txNotifier = context.watch<TransactionNotifier>();
    final transactions = txNotifier.transactions;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.subtitleText(context).withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: Text(
                DateFormat('MMMM yyyy', locale).format(_focusedDay),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text(context),
                ),
              ),
            ),
          ),

          // Calendar PageView
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _focusedDay = _getDateFromIndex(index);
                });
              },
              itemBuilder: (context, index) {
                final monthDate = _getDateFromIndex(index);
                return _buildMonthPage(context, monthDate, transactions, txNotifier.monthlyBudget);
              },
            ),
          ),
          
          // Apply Button Footer
          Container(
            padding: EdgeInsets.only(
              left: 24, 
              right: 24, 
              top: 16,
              bottom: 100 + MediaQuery.of(context).padding.bottom
            ),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              border: Border(
                top: BorderSide(
                  color: AppColors.cardBorder(context),
                  width: 1,
                ),
              ),
            ),
            child: PressableContainer(
              onPressed: () {
                if (_selectedDay != null) {
                  final txNotifier = context.read<TransactionNotifier>();
                  txNotifier.setFilterDateRange(
                    DateTimeRange(start: _selectedDay!, end: _selectedDay!)
                  );
                  Navigator.pop(context);
                }
              },
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  l10n.applySelection,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthPage(BuildContext context, DateTime monthDate, List<Transaction> transactions, double monthlyBudget) {
    // Calculate monthly stats
    final monthlyTransactions = transactions.where((t) => 
      t.date.year == monthDate.year && t.date.month == monthDate.month
    ).toList();

    final totalSpent = monthlyTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
        
    final totalIncome = monthlyTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    // Calculate daily stats for calendar
    Map<int, double> dailyNet = {};
    for (var t in monthlyTransactions) {
      final day = t.date.day;
      if (t.type == TransactionType.income) {
        dailyNet[day] = (dailyNet[day] ?? 0) + t.amount;
      } else if (t.type == TransactionType.expense) {
        dailyNet[day] = (dailyNet[day] ?? 0) - t.amount;
      }
    }

    final locale = Localizations.localeOf(context).toString();
    // Generate localized weekdays starting from Sunday
    final knownSunday = DateTime(2024, 1, 7); 
    final weekDays = List.generate(7, (index) {
      return DateFormat.E(locale).format(knownSunday.add(Duration(days: index)));
    });

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            // Weekday headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: weekDays.map((day) => 
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 48) / 7,
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppColors.subtitleText(context),
                      letterSpacing: 1,
                    ),
                  ),
                )
              ).toList(),
            ),
            const SizedBox(height: 12),
            
            // Days grid
            _buildCalendarGrid(context, monthDate, dailyNet),
            
            const SizedBox(height: 24),
            
            // Monthly Overview Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.cardBorder(context),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DateFormat('MMMM', locale).format(monthDate)} ${AppLocalizations.of(context)!.overview}'.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.subtitleText(context),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Income
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Symbols.arrow_downward_rounded, size: 16, color: AppColors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  AppLocalizations.of(context)!.incomeLabel,
                                  style: TextStyle(
                                    color: AppColors.subtitleText(context),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₺${totalIncome.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Expense
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Symbols.arrow_upward_rounded, size: 16, color: AppColors.expenseColor(context)),
                                const SizedBox(width: 4),
                                Text(
                                  AppLocalizations.of(context)!.expensesLabel,
                                  style: TextStyle(
                                    color: AppColors.subtitleText(context),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₺${totalSpent.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: AppColors.expenseColor(context),
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 120), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context, DateTime monthDate, Map<int, double> dailyNet) {
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final firstDayOfWeek = DateTime(monthDate.year, monthDate.month, 1).weekday % 7;
    final prevMonthDays = DateTime(monthDate.year, monthDate.month, 0).day;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 42, // 6 rows * 7 days
      itemBuilder: (context, index) {
        // Previous month days
        if (index < firstDayOfWeek) {
          final day = prevMonthDays - (firstDayOfWeek - index - 1);
          return Center(
            child: Text(
              '$day',
              style: TextStyle(
                color: AppColors.subtitleText(context).withOpacity(0.3),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          );
        }
        
        // Current month days
        final day = index - firstDayOfWeek + 1;
        if (day <= daysInMonth) {
          final currentDate = DateTime(monthDate.year, monthDate.month, day);
          final isSelected = isSameDay(_selectedDay, currentDate);
          final netAmount = dailyNet[day];
          
          return PressableContainer(
            onPressed: () {
              setState(() {
                _selectedDay = currentDate;
              });
            },
            padding: EdgeInsets.zero,
            pressOffset: 4,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.card(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.cardBorder(context),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected ? AppColors.primaryDark : AppColors.cardBorder(context),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.text(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (netAmount != null && netAmount != 0)
                  Text(
                    '${netAmount > 0 ? '+' : ''}${netAmount.toInt()}',
                    style: TextStyle(
                      color: isSelected 
                          ? Colors.white.withOpacity(0.9)
                          : (netAmount > 0 ? AppColors.primary : Colors.red),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
              ],
            ),
          );
        }
        
        // Next month days
        final nextMonthDay = day - daysInMonth;
        return Center(
          child: Text(
            '$nextMonthDay',
            style: TextStyle(
              color: AppColors.subtitleText(context).withOpacity(0.3),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }
}
