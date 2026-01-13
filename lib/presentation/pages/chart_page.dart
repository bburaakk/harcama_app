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

class _ChartContent extends StatelessWidget {
  final String timeframe;
  const _ChartContent({required this.timeframe});

  @override
  Widget build(BuildContext context) {
    return Selector<TransactionNotifier, List<Transaction>>(
      selector: (context, notifier) => notifier.transactions,
      builder: (context, allTransactions, _) {
        final notifier = context.read<TransactionNotifier>();
        final monthlyBudget = notifier.monthlyBudget;
        
        final filteredTransactions = notifier.getFilteredTransactions(timeframe);
        
        final totalSpent = filteredTransactions
            .where((t) => t.type == TransactionType.expense)
            .fold(0.0, (sum, t) => sum + t.amount);

        return SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              WeeklySpendingChart(transactions: allTransactions, monthlyBudget: monthlyBudget),
              
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
