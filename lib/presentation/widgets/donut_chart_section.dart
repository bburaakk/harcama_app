import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';

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
    final expenses = widget.transactions.where((t) => t.type == TransactionType.expense).toList();

    List<PieChartSectionData> sections = [];
    List<PieChartSectionData> shadowSections = [];

    // Format amount with 2 decimal places if needed, otherwise 0
    String formatAmount(double amount) {
      if (amount % 1 == 0) {
        return '₺${amount.toStringAsFixed(0)}';
      } else {
        return '₺${amount.toStringAsFixed(2)}';
      }
    }

    String centerLabel = 'TOTAL SPENT';
    String centerAmount = formatAmount(widget.totalSpent);

    if (expenses.isNotEmpty && widget.totalSpent > 0) {
      final Map<String, double> categoryTotals = {};
      for (var t in expenses) {
        final categoryName = t.category?.title ?? 'Other';
        categoryTotals[categoryName] = (categoryTotals[categoryName] ?? 0) + t.amount;
      }

      final sortedCategories = categoryTotals.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      if (_touchedIndex != -1) {
        if (_touchedIndex < 4 && _touchedIndex < sortedCategories.length) {
          final entry = sortedCategories[_touchedIndex];
          centerLabel = entry.key.toUpperCase();
          centerAmount = formatAmount(entry.value);
        } else if (_touchedIndex == 4 && sortedCategories.length > 4) {
          double otherTotal = 0;
          for (int i = 4; i < sortedCategories.length; i++) {
            otherTotal += sortedCategories[i].value;
          }
          centerLabel = 'OTHERS';
          centerAmount = formatAmount(otherTotal);
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
        height: 250,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: const Offset(0, 6),
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 80,
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
                centerSpaceRadius: 80,
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

  PieChartSectionData _chartSection(double value, Color color, bool isTouched) {
    return PieChartSectionData(
      color: color,
      value: value,
      title: '',
      radius: isTouched ? 32 : 24,
      showTitle: false,
      badgeWidget: null,
    );
  }
}
