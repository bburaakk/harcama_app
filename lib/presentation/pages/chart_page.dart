import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/chart_legend.dart';
import 'package:harcama_app/presentation/widgets/donut_chart_section.dart';
import 'package:harcama_app/presentation/widgets/timeframe_selector.dart';
import 'package:harcama_app/presentation/widgets/top_expenses_list.dart';
import 'package:harcama_app/presentation/widgets/spending_chart.dart';
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
  int _selectedIndex = 0;
  final List<String> _timeframes = ['Weekly', 'Monthly', 'Yearly'];

  void _onTimeframeSelected(int index) {
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
              child: _ChartContent(timeframe: _timeframes[_selectedIndex]),
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
  late PageController _pageController;
  late DateTime _initialDate;
  final int _initialPage = 1000; // Sabit başlangıç sayfası

  @override
  void initState() {
    super.initState();
    _initialDate = DateTime.now();
    _pageController = PageController(initialPage: _initialPage);
    // initializeDateFormatting çağrısını kaldırdık veya dinamik hale getirebiliriz
    // Ancak main.dart'ta zaten locale desteği eklendiği için burada gerek kalmayabilir
    // Yine de garanti olsun diye boş bir initialize bırakabiliriz veya kaldırabiliriz.
    // Şimdilik kaldırıyorum çünkü main.dart hallediyor.
  }

  @override
  void didUpdateWidget(_ChartContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.timeframe != widget.timeframe) {
      // Reset to initial state when timeframe changes
      _pageController.jumpToPage(_initialPage);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _getDateForPage(int page) {
    final diff = page - _initialPage;
    final now = DateTime.now();
    
    if (widget.timeframe == 'Weekly') {
      return now.add(Duration(days: diff * 7));
    } else if (widget.timeframe == 'Monthly') {
      return DateTime(now.year, now.month + diff, 1);
    } else { // Yearly
      return DateTime(now.year + diff, 1, 1);
    }
  }

  int weekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysOffset = firstDayOfYear.weekday - 1;
    final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
    return ((date.difference(firstMonday).inDays) / 7).floor() + 1;
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    // Cihazın locale'ini al (veya varsayılan olarak 'en_US' kullan)
    // Ancak DateFormat constructor'ında locale belirtmezsek, Intl.defaultLocale kullanılır.
    // Intl.defaultLocale ise main.dart'taki yapılandırma sayesinde cihaz diliyle uyumlu olmalı.
    // Yine de garanti olsun diye null geçiyoruz (varsayılanı kullanması için).

    if (widget.timeframe == 'Weekly') {
      final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      
      // Check if current week
      final currentStart = now.subtract(Duration(days: now.weekday - 1));
      if (startOfWeek.year == currentStart.year && 
          startOfWeek.month == currentStart.month && 
          startOfWeek.day == currentStart.day) {
        return 'THIS WEEK'; // Bunu da yerelleştirmek lazım ama şimdilik kalsın
      }

      if (startOfWeek.year != endOfWeek.year) {
        // Yıl değişiyorsa: 2023 29 Dec - 2024 4 Jan
        final start = DateFormat('yyyy d MMM').format(startOfWeek);
        final end = DateFormat('yyyy d MMM').format(endOfWeek);
        return '$start - $end';
      } else if (startOfWeek.month != endOfWeek.month) {
        // Ay değişiyorsa: 2024 29 Jan - 4 Feb
        final year = startOfWeek.year.toString();
        final start = DateFormat('d MMM').format(startOfWeek);
        final end = DateFormat('d MMM').format(endOfWeek);
        return '$year $start - $end';
      } else {
        // Aynı ay: 2024 19 - 25 Jan
        final year = startOfWeek.year.toString();
        final startDay = startOfWeek.day.toString();
        final end = DateFormat('d MMM').format(endOfWeek);
        return '$year $startDay - $end';
      }

    } else if (widget.timeframe == 'Monthly') {
      if (date.year == now.year && date.month == now.month) {
        return 'THIS MONTH';
      }
      return DateFormat('MMMM yyyy').format(date);
    } else { // Yearly
      if (date.year == now.year) {
        return 'THIS YEAR';
      }
      return DateFormat('yyyy').format(date);
    }
  }

  Future<void> _onDateHeaderTap(BuildContext context, DateTime currentDate) async {
    final now = DateTime.now();
    
    // Pick a date
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000), // Reasonable past limit
      lastDate: now, // Prevent future selection
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.card(context),
              onSurface: AppColors.text(context),
            ),
            dialogBackgroundColor: AppColors.card(context),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      int offset = 0;

      if (widget.timeframe == 'Weekly') {
        // Calculate week difference
        // Normalize to start of week (Monday) to ensure correct diff
        final currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
        final pickedWeekStart = picked.subtract(Duration(days: picked.weekday - 1));
        
        // Difference in days / 7 gives the week offset
        offset = (currentWeekStart.difference(pickedWeekStart).inDays / 7).round();
      } else if (widget.timeframe == 'Monthly') {
        // Calculate month difference
        offset = (now.year - picked.year) * 12 + now.month - picked.month;
      } else { // Yearly
        // Calculate year difference
        offset = now.year - picked.year;
      }

      // Calculate target page (subtract offset because pages go back in time)
      final targetPage = _initialPage - offset;

      // Ensure we don't go out of bounds (future or too far past)
      if (targetPage >= 0 && targetPage <= _initialPage) {
        _pageController.jumpToPage(targetPage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: _initialPage + 1, // 0 to 1000
      onPageChanged: (page) {
        setState(() {}); 
      },
      itemBuilder: (context, index) {
        final date = _getDateForPage(index);
        return _buildPageContent(context, date);
      },
    );
  }

  Widget _buildPageContent(BuildContext context, DateTime date) {
    return Selector<TransactionNotifier, List<Transaction>>(
      selector: (context, notifier) => notifier.transactions,
      builder: (context, allTransactions, _) {
        final notifier = context.read<TransactionNotifier>();
        final monthlyBudget = notifier.monthlyBudget;

        final filteredTransactions = notifier.getFilteredTransactions(
          widget.timeframe,
          referenceDate: date,
        );

        final totalSpent = filteredTransactions
            .where((t) => t.type == TransactionType.expense)
            .fold(0.0, (sum, t) => sum + t.amount);

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Date Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: GestureDetector(
                  onTap: () => _onDateHeaderTap(context, date),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.card(context),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cardBorder(context), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          offset: const Offset(0, 4),
                          blurRadius: 0,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getDateLabel(date).toUpperCase(),
                          style: TextStyle(
                            color: AppColors.text(context),
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 16,
                          color: AppColors.subtitleText(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

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
              
              SpendingChart(
                transactions: allTransactions,
                monthlyBudget: monthlyBudget,
                referenceDate: date,
                timeframe: widget.timeframe,
              ),
              
              if (filteredTransactions.any(
                (t) => t.type == TransactionType.expense,
              )) ...[
                TopExpensesList(transactions: filteredTransactions),
              ],
            ],
          ),
        );
      },
    );
  }
}
