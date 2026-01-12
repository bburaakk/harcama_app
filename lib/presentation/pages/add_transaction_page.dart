import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:harcama_app/domain/entities/category.dart';
import 'package:harcama_app/domain/entities/transaction.dart';
import 'package:harcama_app/presentation/notifiers/transaction_notifier.dart';
import 'package:harcama_app/domain/utility/math_helper.dart';
import 'package:harcama_app/presentation/widgets/keypad.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final ValueNotifier<String> amount = ValueNotifier("0");

  String note = "";
  DateTime selectedDate = DateTime.now();
  Category? selectedCategory;
  TransactionType selectedType = TransactionType.expense;

  final categories = const [
    Category(id: "1", title: "Food", icon: "🍕"),
    Category(id: "2", title: "Transport", icon: "🚌"),
    Category(id: "3", title: "Shopping", icon: "🛍️"),
    Category(id: "4", title: "Rent", icon: "🏠"),
    Category(id: "5", title: "Fun", icon: "🎮"),
  ];

  // ---------------- KEYPAD LOGIC ----------------

  void onKeyTap(String value) {
    var a = amount.value;

    if (value == "⌫") {
      if (a.isNotEmpty) a = a.substring(0, a.length - 1);
      if (a.isEmpty) a = "0";
      amount.value = a;
      return;
    }

    if (value == "=") {
      try {
        final expr = _sanitizeExpression(a);
        final res = calculate(expr);
        amount.value = res.toString().replaceAll(RegExp(r"\.0+$"), "");
      } catch (_) {}
      return;
    }

    if ("+-/".contains(value)) {
      if (RegExp(r'[+\-\/]$').hasMatch(a)) {
        a = a.substring(0, a.length - 1) + value;
      } else {
        a += value;
      }
      amount.value = a;
      return;
    }

    if (value == ".") {
      final parts = RegExp(r"[^+\-\/]+").allMatches(a);
      final last = parts.isNotEmpty ? parts.last.group(0)! : a;
      if (last.contains('.')) return;
    }

    if (a == "0") {
      a = value;
    } else {
      a += value;
    }

    amount.value = a;
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _topBar(context),
            const SizedBox(height: 20),
            _typeSelector(),
            const SizedBox(height: 16),
            _amountView(theme),
            const SizedBox(height: 20),
            _categoryList(theme),
            const SizedBox(height: 16),
            _detailsCard(context, theme),
            const SizedBox(height: 8),
            Expanded(child: KeyPad(onTap: onKeyTap)),
          ],
        ),
      ),
    );
  }

  // ---------------- WIDGETS ----------------

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _iconButton(Icons.close, () => Navigator.pop(context)),
          const Text("New Transaction",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          _iconButton(Icons.check, _saveNewTransaction),
        ],
      ),
    );
  }

  Widget _typeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _typeButton(TransactionType.expense, "Expense", Icons.arrow_downward),
        const SizedBox(width: 12),
        _typeButton(TransactionType.income, "Income", Icons.arrow_upward),
        const SizedBox(width: 12),
        _typeButton(TransactionType.transfer, "Transfer", Icons.swap_horiz),
      ],
    );
  }

  Widget _amountView(ThemeData theme) {
    return Column(
      children: [
        const Text("ENTER AMOUNT",
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.grey)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("₺",
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary)),
            const SizedBox(width: 6),
            ValueListenableBuilder<String>(
              valueListenable: amount,
              builder: (_, value, __) {
                return Text(value,
                    style: const TextStyle(
                        fontSize: 56, fontWeight: FontWeight.w900, height: 1));
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _categoryList(ThemeData theme) {
    return RepaintBoundary(
      child: SizedBox(
        height: 96,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isActive = selectedCategory == cat;

            return GestureDetector(
              onTap: () => setState(() => selectedCategory = cat),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child:
                            Text(cat.icon, style: const TextStyle(fontSize: 26))),
                  ),
                  const SizedBox(height: 6),
                  Text(cat.title,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? theme.colorScheme.primary
                              : Colors.grey)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _detailsCard(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
            color: theme.cardColor, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            _inputRow(
              icon: Icons.edit_note,
              hint: "What is this for?",
              onChanged: (v) => note = v,
            ),
            _divider(),
            _selectRow(
              icon: Icons.calendar_today,
              title: "Date",
              value: DateFormat("EEE, MMM d").format(selectedDate),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeButton(TransactionType type, String label, IconData icon) {
    final isSelected = selectedType == type;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => setState(() => selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 16, color: isSelected ? Colors.white : Colors.grey),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration:
            BoxDecoration(color: Theme.of(context).cardColor, shape: BoxShape.circle),
        child: Icon(icon),
      ),
    );
  }

  Widget _divider() =>
      Divider(height: 1, color: Colors.grey.withOpacity(0.15));

  Widget _inputRow(
      {required IconData icon,
      required String hint,
      required ValueChanged<String> onChanged}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
              child: TextField(
            decoration:
                InputDecoration(hintText: hint, border: InputBorder.none),
            onChanged: onChanged,
          )),
        ],
      ),
    );
  }

  Widget _selectRow(
      {required IconData icon,
      required String title,
      required String value,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 12),
            Text(title),
            const Spacer(),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, size: 18),
          ],
        ),
      ),
    );
  }

  // ---------------- SAVE ----------------

  Future<void> _saveNewTransaction() async {
    final notifier = context.read<TransactionNotifier>();

    final tx = Transaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      ledgerID: "",
      accountID: "",
      title: note.isEmpty ? "Transaction" : note,
      amount: _evaluateAmount(),
      date: selectedDate,
      entryDate: DateTime.now(),
      category: selectedCategory,
      type: selectedType,
    );

    await notifier.addItem(tx);
    if (context.mounted) Navigator.pop(context);
  }

  String _sanitizeExpression(String expr) {
    var e = expr;
    while (e.isNotEmpty && RegExp(r'[+\-\/]$').hasMatch(e)) {
      e = e.substring(0, e.length - 1);
    }
    return e.isEmpty ? '0' : e;
  }

  double _evaluateAmount() {
    try {
      if (amount.value.contains(RegExp(r'[+\-\/]'))) {
        return calculate(_sanitizeExpression(amount.value));
      }
      return double.tryParse(amount.value) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  void dispose() {
    amount.dispose();
    super.dispose();
  }
}
