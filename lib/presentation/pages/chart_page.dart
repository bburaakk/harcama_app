import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/domain/entities/category.dart';
import 'dart:math' as math;

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  String _selectedTimeframe = 'Weekly';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Consumer<TransactionNotifier>(
          builder: (context, notifier, _) {
            final allTransactions = notifier.transactions;
            final monthlyBudget = notifier.monthlyBudget; 
            
            final filteredTransactions = notifier.getFilteredTransactions(_selectedTimeframe);
            
            final totalSpent = filteredTransactions
                .where((t) => t.type == TransactionType.expense)
                .fold(0.0, (sum, t) => sum + t.amount);

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(context),
                  _buildSegmentedControl(context),
                  if (totalSpent > 0) ...[
                    _buildDonutChartSection(context, totalSpent, filteredTransactions),
                    _buildLegend(context, filteredTransactions),
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
                  _buildWeeklySpendingTitle(context),
                  _buildBarChart(context, allTransactions, monthlyBudget),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Center(
        child: Text(
          'Spending Insights',
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder(context), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: ['Weekly', 'Monthly', 'Yearly'].map((timeframe) {
            final isSelected = _selectedTimeframe == timeframe;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTimeframe = timeframe),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primaryDark,
                              offset: const Offset(0, 4),
                              blurRadius: 0,
                            )
                          ]
                        : null,
                  ),
                  child: Text(
                    timeframe.toUpperCase(),
                    style: TextStyle(
                      color: isSelected 
                          ? Colors.white 
                          : (isDark ? AppColors.grayDark400 : const Color(0xFF749A4C)),
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDonutChartSection(BuildContext context, double totalSpent, List<Transaction> transactions) {
    final expenses = transactions.where((t) => t.type == TransactionType.expense).toList();
    
    List<PieChartSectionData> sections = [];
    
    if (expenses.isNotEmpty && totalSpent > 0) {
      final Map<String, double> categoryTotals = {};
      for (var t in expenses) {
        final categoryName = t.category?.title ?? 'Other';
        categoryTotals[categoryName] = (categoryTotals[categoryName] ?? 0) + t.amount;
      }
      
      final sortedCategories = categoryTotals.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
        
      final topCategories = sortedCategories.take(4).toList();
      
      for (int i = 0; i < topCategories.length; i++) {
        final entry = topCategories[i];
        final percentage = (entry.value / totalSpent) * 100;
        final color = [
          AppColors.primary, 
          AppColors.secondaryBlue, 
          AppColors.neonPink, 
          AppColors.secondaryYellow
        ][i % 4];
        sections.add(_chartSection(percentage, color));
      }
      
      if (sortedCategories.length > 4) {
         double otherTotal = 0;
         for (int i = 4; i < sortedCategories.length; i++) {
           otherTotal += sortedCategories[i].value;
         }
         if (otherTotal > 0) {
            final percentage = (otherTotal / totalSpent) * 100;
            sections.add(_chartSection(percentage, AppColors.subtitleText(context)));
         }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SizedBox(
        height: 250,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 80,
                startDegreeOffset: -90,
                sections: sections,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TOTAL SPENT',
                  style: TextStyle(
                    color: AppColors.subtitleText(context),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  '₺${totalSpent.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  PieChartSectionData _chartSection(double value, Color color) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: '',
      radius: 20,
      showTitle: false,
      badgeWidget: null,
    );
  }

  Widget _buildLegend(BuildContext context, List<Transaction> transactions) {
    final expenses = transactions.where((t) => t.type == TransactionType.expense).toList();
    
    if (expenses.isEmpty) {
      return const SizedBox.shrink();
    }

    final Map<String, double> categoryTotals = {};
    final Map<String, String> categoryIcons = {};

    for (var t in expenses) {
      final categoryName = t.category?.title ?? 'Other';
      categoryTotals[categoryName] = (categoryTotals[categoryName] ?? 0) + t.amount;
      
      if (t.category != null) {
        categoryIcons[categoryName] = t.category!.icon;
      }
    }

    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topCategories = sortedCategories.take(4).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.2, 
        ),
        itemCount: topCategories.length,
        itemBuilder: (context, index) {
          final entry = topCategories[index];
          final color = [
            AppColors.primary, 
            AppColors.secondaryBlue, 
            AppColors.neonPink, 
            AppColors.secondaryYellow
          ][index % 4];
          
          String iconString = categoryIcons[entry.key] ?? '';
          Widget iconWidget;
          
          if (iconString.isNotEmpty) {
             final int? codePoint = int.tryParse(iconString);
             if (codePoint != null) {
               iconWidget = Icon(
                 IconData(codePoint, fontFamily: 'MaterialIcons'),
                 color: Colors.white,
                 size: 20,
               );
             } else if (iconString.length <= 2) { 
                iconWidget = Text(iconString, style: const TextStyle(fontSize: 20));
             } else {
                iconWidget = const Icon(Icons.category, color: Colors.white, size: 20);
             }
          } else {
             IconData iconData = Icons.category;
             if (entry.key.toLowerCase().contains('food')) iconData = Icons.restaurant;
             else if (entry.key.toLowerCase().contains('transport')) iconData = Icons.directions_car;
             else if (entry.key.toLowerCase().contains('fun')) iconData = Icons.celebration;
             iconWidget = Icon(iconData, color: Colors.white, size: 20);
          }
          
          return _legendItem(context, iconWidget, entry.key.toUpperCase(), '₺${entry.value.toStringAsFixed(0)}', color);
        },
      ),
    );
  }

  Widget _legendItem(BuildContext context, Widget iconWidget, String label, String amount, Color color) {
    return PressableContainer(
      onPressed: () {},
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder(context), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: iconWidget is Icon ? iconWidget : Center(child: iconWidget),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.subtitleText(context),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  amount,
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySpendingTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Weekly Spending',
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, List<Transaction> transactions, double monthlyBudget) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final endOfWeekDate = startOfWeekDate.add(const Duration(days: 7));

    List<double> dailyTotals = List.filled(7, 0.0);

    for (var t in transactions) {
      if (t.type == TransactionType.expense) {
        if (t.date.isAfter(startOfWeekDate.subtract(const Duration(seconds: 1))) && 
            t.date.isBefore(endOfWeekDate)) {
          int index = t.date.weekday - 1;
          if (index >= 0 && index < 7) {
            dailyTotals[index] += t.amount;
          }
        }
      }
    }

    double maxSpent = dailyTotals.reduce(math.max);
    
    double maxY;
    if (monthlyBudget > 0) {
      double weeklyTarget = monthlyBudget / 4;
      maxY = math.max(maxSpent, weeklyTarget) * 1.1; 
    } else {
      maxY = math.max(maxSpent, 500.0) * 1.1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cardBorder(context), width: 2),
          boxShadow: [
             BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            maxY: maxY,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => AppColors.text(context),
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '₺${rod.toY.toStringAsFixed(0)}',
                    TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.black 
                          : Colors.white, 
                      fontWeight: FontWeight.bold
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const titles = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                    final index = value.toInt();
                    if (index >= 0 && index < titles.length) {
                      final isToday = (index + 1) == now.weekday;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          titles[index],
                          style: TextStyle(
                            color: isToday 
                                ? AppColors.secondaryBlue 
                                : AppColors.subtitleText(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                  reservedSize: 30,
                ),
              ),
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: [
              _makeBarGroup(context, 0, dailyTotals[0], AppColors.primary, maxY),
              _makeBarGroup(context, 1, dailyTotals[1], AppColors.primary, maxY),
              _makeBarGroup(context, 2, dailyTotals[2], AppColors.primary, maxY),
              _makeBarGroup(context, 3, dailyTotals[3], AppColors.primary, maxY),
              _makeBarGroup(context, 4, dailyTotals[4], AppColors.primary, maxY),
              _makeBarGroup(context, 5, dailyTotals[5], AppColors.primary, maxY),
              _makeBarGroup(context, 6, dailyTotals[6], AppColors.primary, maxY),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(BuildContext context, int x, double y, Color color, double maxY) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: y > 0 ? color : Colors.transparent, 
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY,
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white.withOpacity(0.05) 
                : AppColors.gray100,
          ),
        ),
      ],
    );
  }
}
