import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Raporlar'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------- TOP SUMMARY ----------
            _sectionCard(
              child: _monthlySummary(),
            ),
            const SizedBox(height: 25),

            // ---------- LINE CHART ----------
            const Text(
              'Aylık Trend',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            _sectionCard(
              child: SizedBox(height: 220, child: _dummyLineChart()),
            ),

            const SizedBox(height: 28),

            // ---------- BAR CHART ----------
            const Text(
              'Kategori Bazlı Harcama',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            _sectionCard(
              child: SizedBox(height: 220, child: _dummyBarChart()),
            ),

            const SizedBox(height: 28),

            // ---------- TOP 3 ----------
            const Text(
              'En Yüksek 3 Harcama',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),

            _sectionCard(
              child: _dummyTopThree(),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------
  //  SECTION CARD WRAPPER (Duolingo style)
  // ------------------------------------------
  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.06),
          )
        ],
      ),
      child: child,
    );
  }

  // ------------------------------------------
  // SUMMARY CARDS
  // ------------------------------------------
  Widget _monthlySummary() {
    return Row(
      children: [
        Expanded(child: _summaryCard('Toplam Harcama', '4.280 ₺', Icons.wallet)),
        const SizedBox(width: 16),
        Expanded(child: _summaryCard('Kategori Sayısı', '5', Icons.category)),
      ],
    );
  }

  Widget _summaryCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: Colors.green),
          ),
          const SizedBox(height: 14),
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // LINE CHART
  // ------------------------------------------
  Widget _dummyLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(1, 50),
              FlSpot(5, 120),
              FlSpot(10, 80),
              FlSpot(15, 160),
              FlSpot(20, 110),
              FlSpot(25, 220),
              FlSpot(30, 190),
            ],
            isCurved: true,
            barWidth: 4,
            color: Colors.green.shade400,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.shade200.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------
  // BAR CHART
  // ------------------------------------------
  Widget _dummyBarChart() {
    final categories = {
      "Yemek": 1200.0,
      "Market": 850.0,
      "Ulaşım": 430.0,
      "Kira": 1500.0,
      "Eğlence": 300.0,
    };

    final bars = categories.entries.toList();

    return BarChart(
      BarChartData(
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barGroups: bars.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.value,
                width: 20,
                color: Colors.blue.shade400,
                borderRadius: BorderRadius.circular(8),
              )
            ],
          );
        }).toList(),
      ),
    );
  }

  // ------------------------------------------
  // TOP 3 LIST
  // ------------------------------------------
  Widget _dummyTopThree() {
    final dummyExpenses = [
      {"title": "Kira", "amount": 1500.0},
      {"title": "Market Alışverişi", "amount": 470.0},
      {"title": "Restoran", "amount": 320.0},
    ];

    return Column(
      children: dummyExpenses.map((e) {
        return Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                e["title"].toString(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                '${e["amount"]} ₺',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
