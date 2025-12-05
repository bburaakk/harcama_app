import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Raporlar"),
        centerTitle: true,
      ),
      body: Consumer<TransactionNotifier>(
        builder: (context, notifier, _) {
          final transactions = notifier.transactions;

          if (transactions.isEmpty) {
            return const Center(
              child: Text(
                "Henüz hiç işlem yok",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final grouped = _groupByCategoryOrType(transactions);
          final total = grouped.values.fold(0.0, (sum, v) => sum + v);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildTotalCard(total),
                const SizedBox(height: 20),
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 50,
                      sections: _buildPieSections(grouped),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildLegend(grouped),
              ],
            ),
          );
        },
      ),
    );
  }

  // -----------------------------
  // CATEGORY / TYPE GRUPLAMA
  // -----------------------------
  Map<String, double> _groupByCategoryOrType(List<Transaction> list) {
    final map = <String, double>{};

    for (var t in list) {
      final key =
          t.category?.title ?? _typeToString(t.type); // kategori yoksa type ile grupla
      map[key] = (map[key] ?? 0) + t.amount;
    }

    return map;
  }

  String _typeToString(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return "Gider";
      case TransactionType.income:
        return "Gelir";
      case TransactionType.transfer:
        return "Transfer";
    }
  }

  // -----------------------------
  // PIE CHART BÖLÜMLERİ
  // -----------------------------
  List<PieChartSectionData> _buildPieSections(Map<String, double> grouped) {
    final pastelColors = [
      Colors.blueAccent.shade100,
      Colors.greenAccent.shade100,
      Colors.pinkAccent.shade100,
      Colors.orangeAccent.shade100,
      Colors.purpleAccent.shade100,
      Colors.yellowAccent.shade100,
      Colors.tealAccent.shade100,
    ];

    final total = grouped.values.fold(0.0, (s, v) => s + v);
    int index = 0;

    return grouped.entries.map((e) {
      final color = pastelColors[index % pastelColors.length];
      index++;

      final percentage = (e.value / total) * 100;

      return PieChartSectionData(
        value: e.value,
        title: "${percentage.toStringAsFixed(1)}%",
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        color: color,
      );
    }).toList();
  }

  // -----------------------------
  // TOPLAM HARCAMA KARTI
  // -----------------------------
  Widget _buildTotalCard(double total) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const Icon(Icons.assessment, size: 32),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Toplam",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "₺${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // AÇIKLAMA LİSTESİ (Legend)
  // -----------------------------
  Widget _buildLegend(Map<String, double> grouped) {
    final pastelColors = [
      Colors.blueAccent.shade100,
      Colors.greenAccent.shade100,
      Colors.pinkAccent.shade100,
      Colors.orangeAccent.shade100,
      Colors.purpleAccent.shade100,
      Colors.yellowAccent.shade100,
      Colors.tealAccent.shade100,
    ];

    int index = 0;

    return Column(
      children: grouped.entries.map((e) {
        final color = pastelColors[index % pastelColors.length];
        index++;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  e.key,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Text(
                "₺${e.value.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
