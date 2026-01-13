import 'package:flutter/material.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/theme/app_colors.dart';
import 'package:harcama_app/presentation/widgets/pressable_container.dart';
import 'package:harcama_app/domain/utility/currency_helper.dart';

class ChartLegend extends StatelessWidget {
  final List<Transaction> transactions;

  const ChartLegend({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
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

          return _legendItem(context, iconWidget, entry.key.toUpperCase(), "₺${CurrencyHelper.format(entry.value)}", color);
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
}
