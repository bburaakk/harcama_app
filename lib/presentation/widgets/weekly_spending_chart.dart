import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/domain/utility/currency_helper.dart';
import 'package:harcama_app/presentation/notifiers/currency_notifier.dart';
import 'dart:math' as math;
import 'package:harcama_app/l10n/app_localizations.dart';

class WeeklySpendingChart extends StatelessWidget {
  final List<Transaction> transactions;
  final double monthlyBudget;
  final DateTime? referenceDate;

  const WeeklySpendingChart({
    super.key,
    required this.transactions,
    required this.monthlyBudget,
    this.referenceDate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currencySymbol = context.watch<CurrencyNotifier>().currencySymbol;
    final now = referenceDate ?? DateTime.now();
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.weeklySpending,
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        Padding(
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
                        '$currencySymbol${CurrencyHelper.format(rod.toY)}', // Show decimals in tooltip
                        TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold),
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
              swapAnimationDuration: const Duration(milliseconds: 150),
            ),
          ),
        ),
      ],
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
