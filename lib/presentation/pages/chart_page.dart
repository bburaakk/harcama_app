import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/chart_legend.dart';
import 'package:harcama_app/presentation/widgets/date_button.dart';
import 'package:harcama_app/presentation/widgets/donut_chart_section.dart';
import 'package:harcama_app/presentation/widgets/timeframe_selector.dart';
import 'package:harcama_app/presentation/widgets/top_expenses_list.dart';
import 'package:harcama_app/presentation/widgets/weekly_date_card.dart';
import 'package:harcama_app/presentation/widgets/weekly_spending_chart.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;
  final List<String> _timeframes = ['Weekly', 'Monthly', 'Yearly'];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTimeframeSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            TimeframeSelector(
              selectedIndex: _selectedIndex,
              timeframes: _timeframes,
              onTimeframeSelected: _onTimeframeSelected,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _ChartContent(timeframe: 'Weekly'),
                  _ChartContent(timeframe: 'Monthly'),
                  _ChartContent(timeframe: 'Yearly'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartContent extends StatefulWidget {
  final String timeframe;
  const _ChartContent({required this.timeframe});

  @override
  State<_ChartContent> createState() => _ChartContentState();
}

class _ChartContentState extends State<_ChartContent> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    initializeDateFormatting('tr_TR', null).then((_) {
      if (mounted) setState(() {});
    });
  }

  void _setDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  bool _isSamePeriod(DateTime d1, DateTime d2) {
    if (widget.timeframe == 'Weekly') {
      final w1 = d1.subtract(Duration(days: d1.weekday - 1));
      final w2 = d2.subtract(Duration(days: d2.weekday - 1));
      return w1.year == w2.year && w1.month == w2.month && w1.day == w2.day;
    } else if (widget.timeframe == 'Monthly') {
      return d1.year == d2.year && d1.month == d2.month;
    } else if (widget.timeframe == 'Yearly') {
      return d1.year == d2.year;
    }
    return false;
  }

  int weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;
    final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
    return ((date.difference(firstMonday).inDays) / 7).floor() + 1;
  }

  Map<String, String> _getWeeklyDateInfo(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final weekNum = weekNumber(startOfWeek).toString();
    final year = startOfWeek.year.toString();
    final startStr = DateFormat('d MMM', 'tr_TR').format(startOfWeek);
    final endStr = DateFormat('d MMM', 'tr_TR').format(endOfWeek);

    // Check if this week is current week
    final isCurrentWeek = _isSamePeriod(date, now);

    return {
      'year': year,
      'week': isCurrentWeek ? 'BU HAFTA' : 'Hafta $weekNum',
      'range': '$startStr - $endStr',
    };
  }

  String _getFormattedDateLabel(DateTime date) {
    final now = DateTime.now();

    if (widget.timeframe == 'Monthly') {
      if (date.year == now.year && date.month == now.month) {
        return 'BU AY';
      }
      return DateFormat('MMMM yyyy', 'tr_TR').format(date);
    } else if (widget.timeframe == 'Yearly') {
      if (date.year == now.year) {
        return 'BU YIL';
      }
      return DateFormat('yyyy', 'tr_TR').format(date);
    }
    return '';
  }

  List<DateTime> _getPreviousDates() {
    final now = DateTime.now();
    List<DateTime> dates = [];
    int count = 0;

    if (widget.timeframe == 'Weekly') {
      count = 52;
    } else if (widget.timeframe == 'Monthly') {
      count = 24;
    } else if (widget.timeframe == 'Yearly') {
      count = 5;
    }

    for (int i = 0; i < count; i++) {
      if (widget.timeframe == 'Weekly') {
        dates.add(now.subtract(Duration(days: i * 7)));
      } else if (widget.timeframe == 'Monthly') {
        dates.add(DateTime(now.year, now.month - i, 1));
      } else if (widget.timeframe == 'Yearly') {
        dates.add(DateTime(now.year - i, 1, 1));
      }
    }
    return dates;
  }

  Widget _buildDateNavigator(List<DateTime> dates) {
    if (widget.timeframe == 'Weekly') {
      return SizedBox(
        height: 75,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: dates.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final date = dates[index];
            final info = _getWeeklyDateInfo(date);
            return WeeklyDateCard(
              year: info['year']!,
              weekNumber: info['week']!,
              dateRange: info['range']!,
              isSelected: _isSamePeriod(date, _selectedDate),
              onTap: () => _setDate(date),
            );
          },
        ),
      );
    } else {
      return SizedBox(
        height: 75,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: dates.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final date = dates[index];
            return DateButton(
              label: _getFormattedDateLabel(date),
              isSelected: _isSamePeriod(date, _selectedDate),
              onTap: () => _setDate(date),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DateTime> dates = _getPreviousDates();

    return Selector<TransactionNotifier, List<Transaction>>(
      selector: (context, notifier) => notifier.transactions,
      builder: (context, allTransactions, _) {
        final notifier = context.read<TransactionNotifier>();
        final monthlyBudget = notifier.monthlyBudget;

        final filteredTransactions = notifier.getFilteredTransactions(
          widget.timeframe,
          referenceDate: _selectedDate,
        );

        final totalSpent = filteredTransactions
            .where((t) => t.type == TransactionType.expense)
            .fold(0.0, (sum, t) => sum + t.amount);

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDateNavigator(dates),
              const SizedBox(height: 10),
              if (totalSpent > 0) ...[
                DonutChartSection(
                  totalSpent: totalSpent,
                  transactions: filteredTransactions,
                ),
                ChartLegend(transactions: filteredTransactions),
              ] else ...[
                const SizedBox(height: 50),
                Text(
                  "No expenses yet",
                  style: TextStyle(
                    color: AppColors.subtitleText(context),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 50),
              ],
              WeeklySpendingChart(
                transactions: allTransactions,
                monthlyBudget: monthlyBudget,
                referenceDate: _selectedDate,
              ),
              if (allTransactions.any(
                (t) => t.type == TransactionType.expense,
              )) ...[
                TopExpensesList(transactions: allTransactions),
              ],
            ],
          ),
        );
      },
    );
  }
}
