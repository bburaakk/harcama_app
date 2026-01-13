import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/chart_header.dart';
import 'package:harcama_app/presentation/widgets/chart_legend.dart';
import 'package:harcama_app/presentation/widgets/donut_chart_section.dart';
import 'package:harcama_app/presentation/widgets/timeframe_selector.dart';
import 'package:harcama_app/presentation/widgets/top_expenses_list.dart';
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
            const ChartHeader(),
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

  String _getFormattedDateLabel(DateTime date) {
    final now = DateTime.now();

    // --- WEEKLY İÇİN ÖZEL FORMAT (Başlık + Alt Başlık için) ---
    if (widget.timeframe == 'Weekly') {
      final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));

      final weekNum = int.parse(DateFormat('w').format(startOfWeek));
      final year = startOfWeek.year;
      final startStr = DateFormat('d MMM', 'tr_TR').format(startOfWeek);
      final endStr = DateFormat('d MMM', 'tr_TR').format(endOfWeek);

      // Araya \n koyuyoruz ki aşağıdaki Widget bunu bölüp kullansın
      return '$year - Hafta $weekNum\n$startStr - $endStr';
    }

    // --- MONTHLY & YEARLY İÇİN ESKİ FORMAT (Tek Satır) ---
    else if (widget.timeframe == 'Monthly') {
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

  // Tarih seçiciyi duruma göre değiştiren fonksiyon
  Widget _buildDateNavigator(List<DateTime> dates) {
    // 1. Durum: HAFTALIK GÖRÜNÜM (Yeni Tasarım)
    if (widget.timeframe == 'Weekly') {
      return Container(
        height: 60,
        width: double.infinity,
        color: Colors.transparent,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: dates.length,
          itemBuilder: (context, index) {
            final date = dates[index];
            return _DateTabItem(
              label: _getFormattedDateLabel(date),
              isSelected: _isSamePeriod(date, _selectedDate),
              onTap: () => _setDate(date),
            );
          },
        ),
      );
    }
    // 2. Durum: AYLIK ve YILLIK (Eski Buton Tasarımı)
    else {
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
            return _DateButton(
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

        final filteredTransactions = notifier.getFilteredTransactions(widget.timeframe, referenceDate: _selectedDate);

        final totalSpent = filteredTransactions
            .where((t) => t.type == TransactionType.expense)
            .fold(0.0, (sum, t) => sum + t.amount);

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Seçiciyi burada dinamik olarak çağırıyoruz
              _buildDateNavigator(dates),

              const SizedBox(height: 10),

              if (totalSpent > 0) ...[
                DonutChartSection(totalSpent: totalSpent, transactions: filteredTransactions),
                ChartLegend(transactions: filteredTransactions),
              ] else ...[
                const SizedBox(height: 50),
                Text(
                  "No expenses yet",
                  style: TextStyle(
                      color: AppColors.subtitleText(context),
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 50),
              ],
              WeeklySpendingChart(
                transactions: allTransactions,
                monthlyBudget: monthlyBudget,
                referenceDate: _selectedDate,
              ),

              if (allTransactions.any((t) => t.type == TransactionType.expense)) ...[
                TopExpensesList(transactions: allTransactions),
              ],
            ],
          ),
        );
      },
    );
  }
}

// --- YENİ WIDGET (SADECE WEEKLY İÇİN) ---
class _DateTabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateTabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Label string'ini \n karakterine göre bölüyoruz
    final parts = label.split('\n');
    final title = parts.isNotEmpty ? parts[0] : label;
    final subtitle = parts.length > 1 ? parts[1] : null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(bottom: BorderSide(color: Color(0xFFFFD500), width: 3))
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected && subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// --- ESKİ WIDGET (MONTHLY ve YEARLY İÇİN GERİ GELDİ) ---
class _DateButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = const Color(0xFF7BDE12);
    final primaryDarkColor = const Color(0xFF5FB30D);

    final inactiveText = isDark ? const Color(0xFFA0C47D) : const Color(0xFF749A4C);
    final inactiveBg = isDark ? const Color(0xFF253218) : Colors.white;
    final inactiveBorder = isDark ? const Color(0xFF2D3A1E) : const Color(0xFFE5E5E5);
    final inactiveShadow = Colors.black.withValues(alpha: 0.1);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor
              : inactiveBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.transparent : inactiveBorder,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? primaryDarkColor : inactiveShadow,
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : inactiveText,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}