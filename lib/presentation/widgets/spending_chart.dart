import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/domain/utility/currency_helper.dart';
import 'package:harcama_app/presentation/notifiers/currency_notifier.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:harcama_app/l10n/app_localizations.dart';

class SpendingChart extends StatelessWidget {
  final List<Transaction> transactions;
  final double monthlyBudget;
  final DateTime? referenceDate;
  final String timeframe;

  const SpendingChart({
    super.key,
    required this.transactions,
    required this.monthlyBudget,
    this.referenceDate,
    required this.timeframe,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currencySymbol = context.watch<CurrencyNotifier>().currencySymbol;
    final now = referenceDate ?? DateTime.now();
    final locale = Localizations.localeOf(context).toString();
    
    List<double> chartValues = [];
    List<String> chartLabels = [];
    String title = '';

    if (timeframe == 'Weekly') {
      title = l10n.weeklySpendingTitle;
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeekDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      final endOfWeekDate = startOfWeekDate.add(const Duration(days: 7));

      chartValues = List.filled(7, 0.0);
      // Yerelleştirilmiş gün isimleri (Pzt, Sal, Çar...)
      // Ancak yer darlığı nedeniyle tek harf kullanmak daha iyi olabilir.
      // Şimdilik basitçe İngilizce harfleri yerelleştirilmiş kısa gün adlarıyla değiştirelim.
      // DateFormat.E(locale).format(date) -> "Mon" or "Pzt"
      chartLabels = List.generate(7, (index) {
        final day = startOfWeekDate.add(Duration(days: index));
        return DateFormat.E(locale).format(day)[0]; // İlk harfi al
      });

      for (var t in transactions) {
        if (t.type == TransactionType.expense) {
          if (t.date.isAfter(startOfWeekDate.subtract(const Duration(seconds: 1))) &&
              t.date.isBefore(endOfWeekDate)) {
            int index = t.date.weekday - 1;
            if (index >= 0 && index < 7) {
              chartValues[index] += t.amount;
            }
          }
        }
      }
    } else if (timeframe == 'Monthly') {
      title = l10n.monthlySpendingTitle;
      
      // Ayın son gününü bul (Örn: 30, 31 veya 28)
      int lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
      String monthName = DateFormat('MMM', locale).format(now);
      
      // Ayı 5 parçaya böl: 1-7, 8-14, 15-21, 22-28, 29-Son
      chartValues = List.filled(5, 0.0);
      chartLabels = [
        '1 - 7\n$monthName',
        '8 - 14\n$monthName',
        '15 - 21\n$monthName',
        '22 - 28\n$monthName',
        '29 - $lastDayOfMonth\n$monthName'
      ];

      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 1);

      for (var t in transactions) {
        if (t.type == TransactionType.expense) {
          if (t.date.isAfter(startOfMonth.subtract(const Duration(seconds: 1))) &&
              t.date.isBefore(endOfMonth)) {
            
            int day = t.date.day;
            int index = 0;
            if (day <= 7) index = 0;
            else if (day <= 14) index = 1;
            else if (day <= 21) index = 2;
            else if (day <= 28) index = 3;
            else index = 4;

            chartValues[index] += t.amount;
          }
        }
      }
    } else { // Yearly
      title = l10n.yearlySpendingTitle;
      chartValues = List.filled(12, 0.0);
      // Yerelleştirilmiş ay isimlerinin ilk harfleri
      chartLabels = List.generate(12, (index) {
        final date = DateTime(now.year, index + 1, 1);
        return DateFormat.MMM(locale).format(date)[0];
      });

      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear = DateTime(now.year + 1, 1, 1);

      for (var t in transactions) {
        if (t.type == TransactionType.expense) {
          if (t.date.isAfter(startOfYear.subtract(const Duration(seconds: 1))) &&
              t.date.isBefore(endOfYear)) {
            int index = t.date.month - 1;
            if (index >= 0 && index < 12) {
              chartValues[index] += t.amount;
            }
          }
        }
      }
    }

    double maxSpent = chartValues.isEmpty ? 0 : chartValues.reduce(math.max);
    double maxY;
    
    // Hedef çizgisi (Background bar) için maxY hesaplama
    if (timeframe == 'Weekly') {
       double weeklyTarget = monthlyBudget > 0 ? monthlyBudget / 4 : 500.0;
       maxY = math.max(maxSpent, weeklyTarget) * 1.1;
    } else if (timeframe == 'Monthly') {
       double monthlyTarget = monthlyBudget > 0 ? monthlyBudget : 2000.0;
       maxY = math.max(maxSpent, monthlyTarget / 4) * 1.1;
    } else { // Yearly
       double yearlyTargetBar = monthlyBudget > 0 ? monthlyBudget : 2000.0;
       maxY = math.max(maxSpent, yearlyTargetBar) * 1.1;
    }
    
    if (maxY == 0) maxY = 100;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
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
                        '$currencySymbol${CurrencyHelper.format(rod.toY)}',
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
                        final index = value.toInt();
                        if (index >= 0 && index < chartLabels.length) {
                          // Highlight logic
                          bool isHighlighted = false;
                          if (timeframe == 'Weekly') {
                            isHighlighted = (index + 1) == now.weekday;
                          } else if (timeframe == 'Monthly') {
                             int day = now.day;
                             int currentWeekIndex = 0;
                             if (day <= 7) currentWeekIndex = 0;
                             else if (day <= 14) currentWeekIndex = 1;
                             else if (day <= 21) currentWeekIndex = 2;
                             else if (day <= 28) currentWeekIndex = 3;
                             else currentWeekIndex = 4;
                             
                             final today = DateTime.now();
                             if (now.year == today.year && now.month == today.month) {
                               isHighlighted = index == currentWeekIndex;
                             }
                          } else { // Yearly
                             final today = DateTime.now();
                             if (now.year == today.year) {
                               isHighlighted = (index + 1) == today.month;
                             }
                          }

                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              chartLabels[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isHighlighted
                                    ? AppColors.secondaryBlue
                                    : AppColors.subtitleText(context),
                                fontWeight: FontWeight.bold,
                                fontSize: timeframe == 'Monthly' ? 8 : 12, // Sığması için fontu biraz daha küçülttüm
                                height: 1.2,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                      reservedSize: 40,
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(chartValues.length, (index) {
                  return _makeBarGroup(context, index, chartValues[index], AppColors.primary, maxY);
                }),
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
          width: timeframe == 'Yearly' ? 12 : 16,
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
