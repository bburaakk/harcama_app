import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/domain/utility/currency_helper.dart';
import 'package:harcama_app/presentation/notifiers/currency_notifier.dart';
import 'package:harcama_app/l10n/app_localizations.dart';

class DonutChartSection extends StatefulWidget {
  final double totalSpent;
  final List<Transaction> transactions;

  const DonutChartSection({
    super.key,
    required this.totalSpent,
    required this.transactions,
  });

  @override
  State<DonutChartSection> createState() => _DonutChartSectionState();
}

class _DonutChartSectionState extends State<DonutChartSection> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currencySymbol = context.watch<CurrencyNotifier>().currencySymbol;
    final expenses = widget.transactions.where((t) => t.type == TransactionType.expense).toList();

    List<PieChartSectionData> sections = [];
    List<PieChartSectionData> shadowSections = [];

    String centerLabel = l10n.totalSpent;
    String centerAmount = "$currencySymbol${CurrencyHelper.format(widget.totalSpent)}";

    if (expenses.isNotEmpty && widget.totalSpent > 0) {
      final Map<String, double> categoryTotals = {};
      for (var t in expenses) {
        final categoryName = t.category?.title ?? l10n.other;
        categoryTotals[categoryName] = (categoryTotals[categoryName] ?? 0) + t.amount;
      }

      final sortedCategories = categoryTotals.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      if (_touchedIndex != -1) {
        if (_touchedIndex < 4 && _touchedIndex < sortedCategories.length) {
          final entry = sortedCategories[_touchedIndex];
          centerLabel = entry.key.toUpperCase();
          centerAmount = "$currencySymbol${CurrencyHelper.format(entry.value)}";
        } else if (_touchedIndex == 4 && sortedCategories.length > 4) {
          double otherTotal = 0;
          for (int i = 4; i < sortedCategories.length; i++) {
            otherTotal += sortedCategories[i].value;
          }
          centerLabel = l10n.others;
          centerAmount = "$currencySymbol${CurrencyHelper.format(otherTotal)}";
        }
      }

      final topCategories = sortedCategories.take(4).toList();

      for (int i = 0; i < topCategories.length; i++) {
        final entry = topCategories[i];
        final percentage = (entry.value / widget.totalSpent) * 100;
        final isTouched = i == _touchedIndex;

        final color = [
          AppColors.primary,
          AppColors.secondaryBlue,
          AppColors.neonPink,
          AppColors.secondaryYellow
        ][i % 4];

        final shadowColor = [
          AppColors.primaryDark,
          AppColors.secondaryBlueDark,
          const Color(0xFFD33131),
          AppColors.secondaryYellowDark
        ][i % 4];

        sections.add(_chartSection(percentage, color, isTouched));
        shadowSections.add(_chartSection(percentage, shadowColor, isTouched));
      }

      if (sortedCategories.length > 4) {
        double otherTotal = 0;
        for (int i = 4; i < sortedCategories.length; i++) {
          otherTotal += sortedCategories[i].value;
        }
        if (otherTotal > 0) {
          final percentage = (otherTotal / widget.totalSpent) * 100;
          final isTouched = _touchedIndex == 4;
          sections.add(_chartSection(percentage, AppColors.subtitleText(context), isTouched));
          shadowSections.add(_chartSection(percentage, AppColors.grayDark500, isTouched));
        }
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SizedBox(
        height: 300, // Yüksekliği artırdım (250 -> 300)
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, 6),
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 100, // İç yarıçapı artırdım (80 -> 100)
                  startDegreeOffset: -90,
                  sections: shadowSections,
                  pieTouchData: PieTouchData(enabled: false),
                ),
                swapAnimationDuration: const Duration(milliseconds: 150),
              ),
            ),
            PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 100, // İç yarıçapı artırdım (80 -> 100)
                startDegreeOffset: -90,
                sections: sections,
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
              ),
              swapAnimationDuration: const Duration(milliseconds: 150),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  centerLabel,
                  style: TextStyle(
                    color: AppColors.subtitleText(context),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  centerAmount,
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 28, // Yazı boyutunu biraz küçülttüm (32 -> 28) taşmayı önlemek için
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

  PieChartSectionData _chartSection(double value, Color color, bool isTouched) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: '',
      radius: isTouched ? 36 : 28, // Dış halka kalınlığını artırdım (32/24 -> 36/28)
      showTitle: false,
      badgeWidget: null,
    );
  }
}
