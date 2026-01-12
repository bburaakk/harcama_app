import 'package:flutter/material.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/presentation/notifiers/ledger_notifier.dart';
import 'package:harcama_app/presentation/widgets/transaction_card.dart';
import 'package:provider/provider.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearching = false;
  bool showLedgerSheet = false;

  void _toggleLedgerSheet() {
    setState(() {
      showLedgerSheet = !showLedgerSheet;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final txNotifier = context.watch<TransactionNotifier>();
    final ledgerNotifier = context.watch<LedgerNotifier>();

    final activeLedgerId = ledgerNotifier.selectedLedger?.id;

    final visibleTx = activeLedgerId == null || activeLedgerId == 'default'
        ? txNotifier.transactions
        : txNotifier.transactions
            .where((t) => t.ledgerID == activeLedgerId)
            .toList();

    final income = visibleTx
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final expense = visibleTx
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final balance = income - expense;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),

            _ledgerDropdown(context, ledgerNotifier),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    if (!isSearching) ...[
                      _heroCard(context, balance, income, expense),
                      const SizedBox(height: 24),
                    ],
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _transactions(context, visibleTx, txNotifier),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- TOP BAR ----------------

  Widget _topBar(BuildContext context) {
    final txNotifier = context.read<TransactionNotifier>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isSearching
            ? Row(
                key: const ValueKey('search'),
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: "Search transactions...",
                        border: InputBorder.none,
                      ),
                      onChanged: txNotifier.updateSearchQuery,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      txNotifier.updateSearchQuery('');
                      setState(() => isSearching = false);
                    },
                  ),
                ],
              )
            : Row(
                key: const ValueKey('normal'),
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.account_balance_wallet_outlined),
                    iconSize: 28,
                    onPressed: _toggleLedgerSheet,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, size: 26),
                        onPressed: () {
                          setState(() => isSearching = true);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, size: 26),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  // ---------------- LEDGER DROPDOWN ----------------

  Widget _ledgerDropdown(
    BuildContext context,
    LedgerNotifier ledgerNotifier,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      height: showLedgerSheet ? 220 : 0,
      child: ClipRRect(
        borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(24)),
        child: Material(
          elevation: 8,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: ledgerNotifier.ledgers.isEmpty
              ? const Center(child: Text("Ledger yok"))
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: ledgerNotifier.ledgers.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final ledger = ledgerNotifier.ledgers[index];
                    final isSelected =
                        ledger.id == ledgerNotifier.selectedLedger?.id;

                    return ListTile(
                      leading: Text(
                        ledger.icon,
                        style: const TextStyle(fontSize: 22),
                      ),
                      title: Text(
                        ledger.name,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.w900
                              : FontWeight.w600,
                        ),
                      ),
                      trailing:
                          isSelected ? const Icon(Icons.check) : null,
                      onTap: () {
                        ledgerNotifier.selectLedger(ledger);
                        _toggleLedgerSheet();
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }

  // ---------------- HERO CARD ----------------

  Widget _heroCard(
    BuildContext context,
    double balance,
    double income,
    double expense,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: const Color.fromARGB(255, 59, 193, 168),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 12, 119, 121),
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Total Balance",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "₺${balance.toStringAsFixed(2)}",
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 38,
                ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _miniStat(
                context,
                icon: Icons.arrow_downward,
                label: "Income",
                value: income,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              _miniStat(
                context,
                icon: Icons.arrow_upward,
                label: "Expenses",
                value: expense,
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(
    BuildContext context, {
    required IconData icon,
    required String label,
    required double value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withOpacity(0.18),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "₺${value.toStringAsFixed(0)}",
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- TRANSACTIONS ----------------

  Widget _transactions(
    BuildContext context,
    List<Transaction> transactions,
    TransactionNotifier notifier,
  ) {
    final dateFormat = DateFormat('dd MMM, HH:mm');
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (notifier.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(),
      );
    }

    if (transactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Text("No transactions found"),
      );
    }

    return Column(
      children: transactions.reversed.map((t) {
        return TransactionCard(t: t, isDark: isDark, dateFormat: dateFormat);
      }).toList(),
    );
  }
}
